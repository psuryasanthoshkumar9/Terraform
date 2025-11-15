resource "aws_instance" "app" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_grp]

  tags = { Name = "Terraform-EC2" }
}
