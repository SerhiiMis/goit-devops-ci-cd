resource "aws_db_instance" "single_instance" {
  count = var.use_aurora ? 0 : 1

  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = "gp2"
  multi_az             = var.multi_az
  publicly_accessible  = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  parameter_group_name   = aws_db_parameter_group.db_pg_single[count.index].name

  db_name          = var.db_name
  username         = var.master_username
  password         = var.master_password
  skip_final_snapshot = true

  tags = {
    Name = "${var.db_name}-instance"
  }
}