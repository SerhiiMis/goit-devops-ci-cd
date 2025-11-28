resource "kubernetes_namespace" "argo_cd" {
  provider = kubernetes
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  provider = helm
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.53.0"
  namespace        = "argocd"
  create_namespace = false
  
  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.argo_cd 
  ]
}

resource "helm_release" "argo_app" {
  provider = helm
  name             = "django-app-of-apps"
  chart            = "${path.module}/charts"
  namespace        = "argocd"
  create_namespace = false
  
  depends_on = [
    helm_release.argo_cd
  ]
}