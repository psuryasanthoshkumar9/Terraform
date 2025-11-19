output "rds_id" {
  description = "RDS instance identifier"
  value       = aws_db_instance.mysql.id
}

output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.mysql.port
}
