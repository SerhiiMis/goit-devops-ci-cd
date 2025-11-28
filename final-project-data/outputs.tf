output "eks_cluster_name" {
  description = "Name of the EKS cluster."
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "API endpoint for kubectl access."
  value       = module.eks.cluster_endpoint
}

output "ecr_repo_url" {
  description = "Full URL for the ECR repository (for Docker push)."
  value       = module.ecr.repository_url
}

output "vpc_id" {
  description = "The ID of the main VPC."
  value       = module.vpc.vpc_id
}

# --- RDS Database Outputs ---
output "rds_endpoint" {
  description = "Database hostname (Cluster or Instance endpoint)."
  value       = module.rds.db_host
}

output "rds_username" {
  description = "Master username for the database."
  value       = module.rds.master_username
}

output "rds_password" {
  description = "Master password for the database."
  value       = module.rds.master_password
  sensitive   = true
}

# --- CI/CD & Monitoring Access URLs ---

output "jenkins_url" {
  description = "Jenkins LoadBalancer URL (Retrieve this via kubectl after apply)."
  value       = module.jenkins.jenkins_url
}

output "argocd_url" {
  description = "Argo CD LoadBalancer URL (Retrieve this via kubectl after apply)."
  value       = "kubectl get svc argo-cd-argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "grafana_url" {
  description = "Grafana LoadBalancer URL (Retrieve this via kubectl after apply)."
  value       = module.monitoring.grafana_url 
}

output "grafana_admin_password" {
  description = "The hardcoded admin password for Grafana."
  value       = module.monitoring.grafana_admin_password 
  sensitive   = true
}

output "grafana_admin_user" {
  description = "The default admin username for Grafana."
  value       = module.monitoring.grafana_admin_user
}

output "grafana_initial_password" {
  description = "Initial password for Grafana admin user (as set in values.yaml)."
  value       = module.monitoring.grafana_admin_password
  sensitive   = true
}