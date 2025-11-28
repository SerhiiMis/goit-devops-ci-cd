# 🏆 Final Project: AWS DevOps Infrastructure

## Архітектура та Компоненти

Цей проєкт розгортає повний стек AWS, використовуючи Terraform, включаючи EKS, CI/CD та Моніторинг.

### 1. Інфраструктурні Модулі

- **VPC:** Налаштована з приватними та публічними підмережами.
- **EKS:** Kubernetes Cluster з IAM Roles (IRSA) та Worker Nodes.
- **RDS:** Універсальний модуль (Aurora/Single Instance).

### 2. CI/CD та GitOps

- **ECR:** Docker Registry для зберігання образів.
- **Jenkins:** Встановлений через Helm, використовує **Kaniko Agent** (для бездокерної збірки) та **IRSA** (для пушу в ECR).
- **Argo CD:** Встановлений через Helm, використовує **GitOps** (App-of-Apps) для автоматичної синхронізації застосунку.

### 3. Моніторинг та Масштабування

- **Prometheus:** Збір метрик Pod'ів та Node'ів.
- **Grafana:** Візуалізація метрик (Admin Password: `password123`).
- **HPA (Horizontal Pod Autoscaler):** Налаштований у Helm-чарті, використовує метрики Pod'ів для автомасштабування застосунку.

---

## 🛠️ Інструкція з Розгортання

### Крок 1: Підготовка

1.  **Встановіть залежності:** `aws-cli`, `kubectl`, `helm`, `terraform`.
2.  Перейдіть у папку проєкту та запустіть ініціалізацію бекенду:
    ```bash
    terraform init
    ```

### Крок 2: Розгортання (Single Command)

Виконайте команду розгортання:

```bash
terraform apply --auto-approve
```

### Крок 3: Перевірка Доступу (Після Apply)

Після успішного розгортання отримайте кінцеві точки:

| Компонент        | Команда для отримання URL / Пароля                                                                          |
| ---------------- | ----------------------------------------------------------------------------------------------------------- |
| Jenkins URL      | `kubectl get svc jenkins -n jenkins -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"`               |
| Argo CD URL      | `kubectl get svc argo-cd-argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"`  |
| Grafana URL      | `kubectl get svc prometheus-grafana -n monitoring -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"` |
| Argo CD Password | `kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}"`                   |

## 📝 Демонстрація CI/CD

Jenkins Pipeline (Jenkinsfile): Налаштований для збірки образу, пушу в ECR та оновлення тегу в Git.

Argo CD: Моніторить charts/django-app і забезпечує GitOps синхронізацію.

## 🗑️ Видалення Інфраструктури

Обов'язково видаліть ресурси після перевірки, щоб уникнути витрат:

```bash
terraform destroy --auto-approve
```
