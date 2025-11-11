resource "aws_security_group" "web_sg" {
  name        = "${var.project_prefix}-web-sg-${random_string.suffix.result}"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_prefix}-web-sg" }
}

# Lambda will not need inbound rules (invoked by EventBridge); create minimal SG
resource "aws_security_group" "lambda_sg" {
  name        = "${var.project_prefix}-lambda-sg-${random_string.suffix.result}"
  description = "Lambda SG"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
