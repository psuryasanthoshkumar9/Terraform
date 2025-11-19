variable "environment" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-ec2"
    Env  = var.environment
  }

  # simple user_data to show instance is created (optional)
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello from ${var.environment}" > /etc/motd
              EOF
}
