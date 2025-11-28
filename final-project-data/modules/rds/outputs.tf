output "db_host" {
  description = "Універсальний Hostname для підключення (Endpoint)."
  value       = var.use_aurora ? join("", aws_rds_cluster.aurora_cluster.*.endpoint) : join("", aws_db_instance.single_instance.*.address)
}

output "db_port" {
  description = "Універсальний Port для підключення."
  value       = var.use_aurora ? join("", aws_rds_cluster.aurora_cluster.*.port) : join("", aws_db_instance.single_instance.*.port)
}

output "db_name" {
  description = "Ім'я бази даних."
  value       = var.db_name
}

output "master_username" {
  description = "Ім'я користувача БД."
  value       = var.master_username
}

output "master_password" {
  description = "Пароль користувача БД."
  value       = var.master_password
  sensitive   = true
}

output "security_group_id" {
  description = "ID Security Group для доступу до БД."
  value       = aws_security_group.db_sg.id
}

output "db_engine" {
  description = "Обраний тип двигуна БД."
  value       = var.engine
}

output "db_type" {
  description = "Тип розгорнутої БД (Aurora чи Single Instance)."
  value       = var.use_aurora ? "Aurora Cluster" : "Single RDS Instance"
}