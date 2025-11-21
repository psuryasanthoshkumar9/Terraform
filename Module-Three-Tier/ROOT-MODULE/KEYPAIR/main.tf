resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "${var.project_name}-keypair"
  public_key = tls_private_key.rsa.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.rsa.private_key_pem
  sensitive = true
}

output "key_name" {
  value = aws_key_pair.generated.key_name
}
