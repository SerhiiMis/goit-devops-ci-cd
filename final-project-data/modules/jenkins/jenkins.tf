resource "kubernetes_namespace" "jenkins" {
  provider = kubernetes
  metadata {
    name = "jenkins"
  }
}

resource "helm_release" "jenkins" {
  provider = helm
  name       = "jenkins"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "jenkins"
  version    = "12.3.0"
  namespace  = "jenkins"
  timeout = 900
  create_namespace = false
  
  values = [
    templatefile("${path.module}/values.yaml", {
      jenkins_admin_password = var.jenkins_admin_password
      jenkins_irsa_role_arn  = aws_iam_role.jenkins_irsa_role.arn
      aws_region             = var.aws_region
    })
  ]
  
  depends_on = [
    aws_iam_role_policy_attachment.jenkins_ecr_attach,
    kubernetes_namespace.jenkins
  ]
}