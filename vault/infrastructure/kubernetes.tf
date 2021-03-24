data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

resource "kubernetes_secret" "example" {
  metadata {
    name = "vault-creds"
    namespace = "vault"
  }

  data = {
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.vault_access_key.id
    AWS_ACCESS_KEY_ID = aws_iam_access_key.vault_access_key.secret
  }
}