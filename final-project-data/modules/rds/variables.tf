variable "vpc_id" {
  description = "VPC ID, де буде розгорнуто RDS."
  type        = string
}

variable "private_subnet_ids" {
  description = "Список Private Subnet ID для DB Subnet Group."
  type        = list(string)
}

variable "db_name" {
  description = "Ім'я бази даних."
  type        = string
  default     = "django_db"
}

variable "master_username" {
  description = "Ім'я користувача бази даних."
  type        = string
  default     = "dbmaster"
}

variable "master_password" {
  description = "Пароль користувача бази даних."
  type        = string
  sensitive   = true
}

variable "use_aurora" {
  description = "Якщо true, створює Aurora Cluster; якщо false, створює одну RDS Instance."
  type        = bool
  default     = false
}

variable "engine" {
  description = "Тип двигуна БД (наприклад, postgres, aurora-postgresql, mysql)."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Версія двигуна БД."
  type        = string
  default     = "16.1"
}

variable "instance_class" {
  description = "Клас інстансу RDS/Aurora (наприклад, db.t3.medium)."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Розмір сховища у ГБ (для звичайної RDS)."
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Включення Multi-AZ (для звичайної RDS)."
  type        = bool
  default     = true
}