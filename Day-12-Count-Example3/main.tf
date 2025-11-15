terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 2
}

locals {
  name_prefix = "${var.name_prefix}-${random_id.suffix.hex}"
}

# ===============================================================
# S3 BUCKET + VERSIONING + LIFECYCLE (2025 syntax, error-free)
# ===============================================================

resource "aws_s3_bucket" "artifact" {
  bucket        = "${local.name_prefix}-artifacts"
  force_destroy = true

  tags = {
    Name = "${local.name_prefix}-artifacts"
    Env  = var.env
  }
}

# ---------------------------------------------------------------
# VERSIONING
# ---------------------------------------------------------------
resource "aws_s3_bucket_versioning" "artifact_versioning" {
  bucket = aws_s3_bucket.artifact.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ---------------------------------------------------------------
# LIFECYCLE RULES (requires filter {} in 2025+)
# ---------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "artifact_lifecycle" {
  bucket = aws_s3_bucket.artifact.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    # NEW REQUIREMENT: one of filter or prefix is mandatory
    filter {
      prefix = ""  # empty = apply to entire bucket
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.artifact_versioning
  ]
}


# ===============================================================
# DynamoDB TABLE
# ===============================================================

resource "aws_dynamodb_table" "kv" {
  name         = "${local.name_prefix}-kv"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  tags = {
    Name = "${local.name_prefix}-kv"
    Env  = var.env
  }
}

# ===============================================================
# IAM ROLE + POLICY FOR LAMBDA
# ===============================================================

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.name_prefix}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  tags = {
    Env = var.env
  }
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    sid     = "logs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    sid = "dynamodb"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:UpdateItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [aws_dynamodb_table.kv.arn]
  }

  statement {
    sid = "s3access"
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = ["${aws_s3_bucket.artifact.arn}/*"]
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${local.name_prefix}-lambda-policy"
  policy = data.aws_iam_policy_document.lambda_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "attach_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# ===============================================================
# CLOUDWATCH LOG GROUP
# ===============================================================

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.name_prefix}-handler"
  retention_in_days = 14
}

# ===============================================================
# LAMBDA FUNCTION
# ===============================================================

resource "aws_lambda_function" "handler" {
  filename         = var.lambda_zip_path
  function_name    = "${local.name_prefix}-handler"
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = filebase64sha256(var.lambda_zip_path)
  timeout          = 10

  environment {
    variables = {
      DDB_TABLE = aws_dynamodb_table.kv.name
      S3_BUCKET = aws_s3_bucket.artifact.bucket
    }
  }

  depends_on = [aws_iam_role_policy_attachment.attach_basic]

  tags = {
    Env = var.env
  }
}

# ===============================================================
# API GATEWAY v2 (HTTP API)
# ===============================================================

resource "aws_apigatewayv2_api" "http_api" {
  name          = "${local.name_prefix}-http-api"
  protocol_type = "HTTP"
}

resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                  = aws_apigatewayv2_api.http_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = aws_lambda_function.handler.invoke_arn
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}
