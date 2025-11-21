# Generate a random suffix for the Security Group to avoid duplicates
resource "random_id" "sg_suffix" {
  byte_length = 2
}

# Generate private/public key automatically
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create AWS key pair using the generated public key
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Security Group for EC2
resource "aws_security_group" "this" {
  name   = "${var.project_name}-${var.environment}-sg-${random_id.sg_suffix.hex}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    prevent_destroy = false
  }
}

# EC2 Instances
resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = element(var.subnets_ids, count.index)
  vpc_security_group_ids = var.security_group_ids   # <- use variable
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-${count.index + 1}"
  }
}

# Outputs
output "security_group_id" {
  value = aws_security_group.this.id
}

output "ec2_ids" {
  value = aws_instance.this[*].id
}

output "private_key_pem" {
  value     = tls_private_key.ec2_key.private_key_pem
  sensitive = true
}
