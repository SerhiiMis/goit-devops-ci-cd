locals {
  db_engine_major_version = var.engine == "postgres" || var.engine == "aurora-postgresql" ? substr(var.engine_version, 0, 2) : substr(var.engine_version, 0, 3)

  final_db_family = var.use_aurora ? (
    var.engine == "aurora-postgresql" ? "aurora-postgresql${local.db_engine_major_version}" : 
    "aurora-mysql${local.db_engine_major_version}"
  ) : (
    var.engine == "postgres" ? "postgres${local.db_engine_major_version}" : 
    "mysql${local.db_engine_major_version}"
  )

  max_connections_map = {
    "db.t3.micro"  = "100"
    "db.t3.small"  = "200"
    "db.t3.medium" = "400"
    "db.r6g.large" = "1000"
  }
}

# 1. DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.db_name}-subnet-group"
  }
}

# 2. Security Group
resource "aws_security_group" "db_sg" {
  name        = "${var.db_name}-sg"
  description = "Allow inbound traffic from VPC only"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow VPC traffic to DB"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
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

# 3. Parameter Group (для звичайної RDS Instance)
resource "aws_db_parameter_group" "db_pg_single" {
  count       = var.use_aurora ? 0 : 1
  name_prefix = "${var.db_name}-pg-single-"
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

# 4. Parameter Group (для Aurora Cluster)
resource "aws_rds_cluster_parameter_group" "db_pg_cluster" {
  count       = var.use_aurora ? 1 : 0
  name_prefix = "${var.db_name}-pg-cluster-"
  family      = local.final_db_family

  parameter {
    name  = "log_statement"
    value = "all"
  }
  
  tags = {
    Name = "${var.db_name}-cluster-param-group"
  }
}