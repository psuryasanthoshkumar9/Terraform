output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.web_sg.id
}
