# 🚀 Універсальний Модуль RDS (База Даних)

Цей модуль реалізує універсальне розгортання бази даних на AWS, підтримуючи як стандартні RDS-інстанси, так і кластери Aurora, за допомогою єдиного виклику.

## 1. Як Використовувати Модуль

Модуль використовує змінну `use_aurora` для умовного створення ресурсів.

### Приклад 1: Звичайна RDS Instance (PostgreSQL)

```terraform
resource "random_password" "db_master" {
  length = 16
  special = true
  override_special = "!#$%&*()_+"
}

module "rds_single" {
  source             = "./modules/rds"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # Вибір типу
  use_aurora         = false

  # Облікові дані та конфігурація
  db_name            = "app_db"
  master_username    = "app_user"
  master_password    = random_password.db_master.result

  engine             = "postgres"
  engine_version     = "16.1"
  instance_class     = "db.t3.medium"
  multi_az           = true # Висока доступність
}
```

### Приклад 2: Aurora Cluster (PostgreSQL)

```terraform

module "rds_aurora" {
source = "./modules/rds"

vpc_id = module.vpc.vpc_id
private_subnet_ids = module.vpc.private_subnets

# Вибір типу

use_aurora = true

# Облікові дані та конфігурація

db_name = "app_aurora"
master_username = "aurora_master"
master_password = random_password.db_master.result

engine = "aurora-postgresql"
engine_version = "14.6"
instance_class = "db.t3.small"
}
```

## 2. Опис Змінних

`vpc_id` (string, N/A): ID VPC, у якій буде розміщено базу даних.

`private_subnet_ids` (list(string), N/A): ID приватних підмереж для DB Subnet Group. БД буде розгорнута в цих мережах.

`db_name` (string, за замовчуванням: django_db): Ім'я бази даних, що створюється.

`master_username` (string, за замовчуванням: dbmaster): Ім'я користувача для адміністративного доступу до БД.

`master_password` (string, N/A): Пароль користувача (чутливі дані, передається через sensitive=true).

`use_aurora` (bool, за замовчуванням: false): Керуючий перемикач. Якщо true, створюється Aurora Cluster. Якщо false, створюється Single RDS Instance.

`engine` (string, за замовчуванням: postgres): Тип двигуна БД (наприклад, postgres, mysql, aurora-postgresql).

`engine_version` (string, за замовчуванням: 16.1): Версія двигуна БД.

`instance_class` (string, за замовчуванням: db.t3.micro): Клас потужності інстансу (наприклад, db.t3.medium). Використовується для визначення max_connections.

`allocated_storage` (number, за замовчуванням: 20): Розмір сховища у ГБ (використовується лише для Single RDS Instance).

`multi_az` (bool, за замовчуванням: true): Включення Multi-AZ (використовується лише для Single RDS Instance для високої доступності).
