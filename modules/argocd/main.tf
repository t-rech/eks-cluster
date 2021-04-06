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

resource "helm_release" "istio_vs_gateway" {
  name  = "argo-cd-istio"
  chart = "./charts/istio-vs-gw"

  namespace = "argocd"

  force_update = true

  set {
    name  = "tls.credentialName"
    value = "acme-ca-tls"
  }

  set {
    name  = "host"
    value = "${var.service_subdomain}.${var.hosted_zone}"
  }

  depends_on = [
    helm_release.argocd
  ]
}