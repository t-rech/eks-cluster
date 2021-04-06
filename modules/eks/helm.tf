resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version = "5.8.0"

  namespace = "kube-system"

  set {
    name  = "apiService.create"
    value = "true"
  }

  depends_on = [
    module.eks
  ]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "cluster-autoscaler"
  version    = "9.9.0"

  namespace  = "kube-system"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "autoDiscovery.tags[0][1]"
    value = "k8s.io/cluster-autoscaler/${var.cluster_name}"
  }

  set {
    name  = "image.tag"
    value = "v1.19.1"
  }

  depends_on = [
    module.eks
  ]
}
