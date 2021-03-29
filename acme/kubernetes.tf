resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.2.0"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}
resource "kubernetes_secret" "cert_manager_secret" {
  metadata {
    name      = "cert-manager-aws-service-account-user"
    namespace = "cert-manager"
  }

  data = {
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.cert_manager_access_key.secret
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.cert_manager_access_key.id
  }

  depends_on = [
    helm_release.cert_manager
  ]
}

resource "helm_release" "ca_issuer" {
  name  = "lets-encrypt-issuer"
  chart = "./charts/lets-encrypt-issuer"

  set {
    name  = "clusterIssuer.route53.region"
    value = var.region
  }

  set {
    name  = "clusterIssuer.route53.accessKeyID"
    value = aws_iam_access_key.cert_manager_access_key.id
  }

  set {
    name  = "clusterIssuer.server"
    value = "https://acme-v02.api.letsencrypt.org/directory"
  }

  set {
    name  = "clusterIssuer.route53.secretAccessKeySecretRef.name"
    value = "cert-manager-aws-service-account-user"
  }

  set {
    name  = "clusterIssuer.route53.secretAccessKeySecretRef.key"
    value = "AWS_SECRET_ACCESS_KEY"
  }

  depends_on = [
    helm_release.cert_manager
  ]
}