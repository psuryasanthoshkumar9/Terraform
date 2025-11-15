output "instance_id" {
  value = aws_instance.example.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "project_tags" {
  value = local.tags
}
