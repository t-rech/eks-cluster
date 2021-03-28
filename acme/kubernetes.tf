resource "kubernetes_secret" "cert_manager_secret" {
  metadata {
    name = "cert-manager-aws-service-account-user"
    namespace = "cert-manager"
  }

  data = {
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.cert_manager_access_key.secret
    AWS_ACCESS_KEY_ID = aws_iam_access_key.cert_manager_access_key.id
  }
}

resource "helm_release" "ca-issuer" {
  name       = "lets-encrypt-issuer"
  chart      = "./charts/lets-encrypt-issuer"

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
}