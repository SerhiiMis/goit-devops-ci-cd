output "grafana_url" {
  description = "Instruction to find the Grafana LoadBalancer endpoint." 
  value       = "kubectl get svc prometheus-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "grafana_admin_password" {
  description = "The hardcoded admin password for Grafana."
  value       = "password123" 
  sensitive   = true
}

output "grafana_admin_user" {
  description = "The default admin username for Grafana."
  value       = "admin"
}