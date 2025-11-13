########################
# modules/ec2/main.tf
########################

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_grp_id]
  key_name               = aws_key_pair.generated.key_name

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]

    connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = tls_private_key.ec2_key.private_key_pem
  host        = self.public_ip
}


  }

  tags = { Name = "day10-web-instance" }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}