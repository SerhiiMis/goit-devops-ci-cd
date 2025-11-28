resource "kubernetes_namespace" "monitoring" {
  provider = kubernetes
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  provider = helm
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "56.0.0" 
  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false
  
  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

data "kubernetes_secret" "grafana_password" {
  provider  = kubernetes
  metadata {
    name      = "prometheus-grafana" 
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  depends_on = [helm_release.prometheus]
}