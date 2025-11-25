# Lesson 7: Jenkins, Agro CD + CD

# 🚀 CI/CD Pipeline: Jenkins + Helm + Terraform + Argo CD

Цей проєкт реалізує повний GitOps CI/CD пайплайн для Django-застосунку на AWS EKS.

---

## 💡 Схема Пайплайну (GitOps Flow)

1. Розробник пушить код у Git.
2. **Jenkins** (розгорнутий у EKS) ініціює Pipeline:
   - Збирає Docker-образ за допомогою **Kaniko**.
   - Пушить образ до **Amazon ECR** (використовуючи IRSA).
   - Оновлює тег образу у файлі **`lesson-8-9/charts/django-app/values.yaml`** та пушить зміну назад у Git (монорепо).
3. **Argo CD** (розгорнутий у EKS) постійно моніторить Git-репозиторій.
4. Argo CD автоматично застосовує оновлений Helm-чарт до кластера EKS.

---

## 🛠️ Як Застосувати Terraform

Вся інфраструктура (VPC, ECR, EKS, Jenkins, Argo CD) була розгорнута за два етапи, щоб обійти проблеми залежностей провайдерів.

### 1. Ініціалізація та Розгортання

Виконайте ці команди у папці `lesson-8-9/`:

# 1. Ініціалізація (підключення до S3/DynamoDB бекенду)

```bash
terraform init
```

# 2. Розгортання всієї інфраструктури (EKS, ECR, Jenkins, Argo CD)

# Всі необхідні IAM/Kubernetes-ресурси створюються автоматично.

```bash
terraform apply --auto-approve
```
