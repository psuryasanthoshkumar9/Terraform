output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.server.id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.server.public_ip
}

output "instance_private_ip" {
  description = "EC2 private IP"
  value       = aws_instance.server.private_ip
}
