output "jenkins_url" {
  description = "Jenkins Service URL (NodePort or LoadBalancer)"
  value       = "You need to run kubectl get svc -n jenkins to find the service endpoint."
}

output "jenkins_admin_password" {
  description = "Initial Jenkins admin password"
  value       = var.jenkins_admin_password
  sensitive   = true
}

output "jenkins_irsa_role_arn" {
  description = "ARN of the Jenkins IRSA role"
  value       = aws_iam_role.jenkins_irsa_role.arn
}