resource "kubernetes_namespace" "argocd" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name = "argo-cd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "2.14.7"

  namespace = "argocd"

  values = [
    "${file("values.yaml")}"
  ]

  depends_on = [kubernetes_namespace.argocd]
}
