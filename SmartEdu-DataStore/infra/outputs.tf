output "ci_instance_public_ip" {
  description = "Public IP for the CI/jenkins host"
  value       = aws_instance.ci.public_ip
}
