resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from Terraform EC2 with User Data! ${random_string.suffix.result}</h1>" > /var/www/html/index.html
  EOT

  tags = {
    Name = "${var.project_prefix}-web-${random_string.suffix.result}"
  }

  depends_on = [
    aws_route_table_association.a,
    aws_route_table_association.b
  ]
}
