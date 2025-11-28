# Lesson 7: Kubernetes Cluster with EKS, Terraform, and Helm

![AWS](https://img.shields.io/badge/AWS-EKS-orange) ![Terraform](https://img.shields.io/badge/Terraform-1.6+-purple) ![Helm](https://img.shields.io/badge/Helm-3.0-blue)

Цей проект розгортає інфраструктуру Kubernetes (EKS) на AWS, налаштовує ECR та автоматично деплоїть Django-застосунок за допомогою Helm.

## 📂 Структура проекту

```text
lesson-7/
├── main.tf # Головна конфігурація (Providers, Modules, Helm Release)
├── outputs.tf # Виводи (Endpoints, URLs)
├── modules/ # Локальні модулі
│ ├── eks/ # Кластер EKS та Node Groups
│ ├── vpc/ # Мережа (VPC, Subnets, IGW)
│ ├── ecr/ # Репозиторій Docker образів
│ └── s3-backend/ # (Опціонально) Зберігання Terraform state
└── charts/
└── django-app/ # Helm чарт застосунку
├── templates/ # Manifests (Deployment, Service, HPA)
├── values.yaml # Конфігурація чарту
└── Chart.yaml # Метадані чарту
```

## 🚀 Передумови (Prerequisites)

Перед початком роботи переконайтеся, що у вас встановлені наступні інструменти:

| Інструмент    | Версія     | Примітка                                                  |
| ------------- | ---------- | --------------------------------------------------------- |
| **Terraform** | `>= 1.6.0` | Для управління інфраструктурою                            |
| **AWS CLI**   | `v2`       | Налаштований через `aws configure`                        |
| **Helm**      | `v3+`      | Для управління релізами Kubernetes                        |
| **Kubectl**   | `v1.30`    | Клієнт для Kubernetes (має співпадати з версією кластера) |

## 🛠 Інструкція по запуску

### 1. Ініціалізація

Завантажте необхідні провайдери та модулі Terraform:

```bash
terraform init
```

### 2. Розгортання (Deploy)

Створіть інфраструктуру та запустіть застосунок однією командою.

Примітка: Процес займає 10-15 хвилин, оскільки AWS EKS потребує часу на створення Control Plane.

```bash
terraform apply -auto-approve
```

### 3. Перевірка результату

Після завершення команди apply, отримайте DNS-адресу Load Balancer'а за допомогою AWS CLI:

```bash
aws elbv2 describe-load-balancers --region us-west-2 --query "LoadBalancers[*].DNSName" --output text
```

Скопіюйте отримане посилання в браузер. Ви повинні побачити стартову сторінку Django.

## ⚙️ Технічні деталі реалізації

EKS Cluster: Версія 1.30.

Networking: Використовуються Public Subnets для робочих нод.

Це дозволяє нодам мати доступ до Інтернету (для завантаження образів Docker) без необхідності створювати дорогий NAT Gateway.

Використовуються інстанси t3.small.

Економічно ефективні для навчальних цілей та сумісні з більшістю регіонів.

Helm-чарт встановлюється автоматично через Terraform-провайдер helm, використовуючи метод аутентифікації exec. Це найнадійніший спосіб роботи з EKS.

## 🧹 Очищення ресурсів (Destroy)

Щоб зупинити нарахування плати за ресурси AWS (EKS, EC2, Load Balancer), обов'язково виконайте знищення інфраструктури після завершення роботи:

```bash
terraform destroy -auto-approve
```
