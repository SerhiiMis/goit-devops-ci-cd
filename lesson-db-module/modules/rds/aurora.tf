resource "aws_rds_cluster" "aurora_cluster" {
  count = var.use_aurora ? 1 : 0 

  cluster_identifier     = "${var.db_name}-cluster"
  engine                 = var.engine
  engine_version         = var.engine_version
  database_name          = var.db_name
  master_username        = var.master_username
  master_password        = var.master_password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_cluster_parameter_group_name = aws_db_parameter_group.db_pg.name
  backup_retention_period = 5
  skip_final_snapshot     = true

  tags = {
    Name = "${var.db_name}-cluster"
  }
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier   = aws_rds_cluster.aurora_cluster[count.index].id
  engine               = aws_rds_cluster.aurora_cluster[count.index].engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false

  tags = {
    Name = "${var.db_name}-instance-${count.index + 1}"
  }
}