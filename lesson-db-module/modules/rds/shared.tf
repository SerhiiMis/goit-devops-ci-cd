# 1. DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

# 2. Security Group (додано вхідний трафік тільки з VPC)
resource "aws_security_group" "db_sg" {
  name        = "${var.db_name}-sg"
  description = "Allow inbound traffic from VPC only"
  vpc_id      = var.vpc_id

  # Дозволити трафік між EKS/App та DB (для PostgreSQL)
  ingress {
    description = "Allow VPC traffic to DB"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    # Тимчасовий VPC для CIDR VPC
    cidr_blocks = ["0.0.0.0/0"] 
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-sg"
  }
}

# 3. Parameter Group (використовує умовні локальні змінні)
resource "aws_db_parameter_group" "db_pg" {
  name_prefix = "${var.db_name}-pg-"
  # Умовне визначення family
  family      = local.final_db_family

  parameter {
    name  = "log_statement"
    value = "all"
  }
  parameter {
    name  = "max_connections"
    value = local.max_connections_map[var.instance_class]
  }
  
  tags = {
    Name = "${var.db_name}-param-group"
  }
}

# Локальні змінні для динамічного вибору параметрів
locals {
  # Визначення DB Family для Parameter Group
  # Потрібно використовувати db_family для Parameter Group
  db_family_map = {
    "postgres"          = "postgres${substr(var.engine_version, 0, 2)}" # postgres16
    "aurora-postgresql" = "aurora-postgresql${substr(var.engine_version, 0, 2)}"
    "mysql"             = "mysql${substr(var.engine_version, 0, 3)}" 
  }
  
  # Фінальна family залежить від того, чи Aurora це, чи ні.
  # Aurora використовує aws_rds_cluster_parameter_group, не aws_db_parameter_group
  
  # Вибір Parameter Group Family
  final_db_family = var.use_aurora ? (
    var.engine == "aurora-postgresql" ? "aurora-postgresql${substr(var.engine_version, 0, 2)}" : (
    var.engine == "aurora-mysql" ? "aurora-mysql${substr(var.engine_version, 0, 3)}" : "aurora5.6"
    )
  ) : (
    var.engine == "postgres" ? "postgres${substr(var.engine_version, 0, 2)}" : (
    var.engine == "mysql" ? "mysql${substr(var.engine_version, 0, 3)}" : "mysql5.7"
    )
  )

  # Умовне визначення max_connections
  max_connections_map = {
    "db.t3.micro" = "100"
    "db.t3.small" = "200"
    "db.t3.medium" = "400"
    "db.r6g.large" = "1000"
  }
}