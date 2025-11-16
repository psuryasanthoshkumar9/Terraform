########################
# modules/networking/outputs.tf
########################

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}
output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}
output "private_subnet_id_1" {
  value = aws_subnet.private1.id
}

output "private_subnet_id_2" {
  value = aws_subnet.private2.id
}
