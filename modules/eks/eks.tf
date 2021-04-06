data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "14.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = var.environment
  }

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    work_nodes = {
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t3.medium"]
      k8s_labels = {
        Environment = var.environment
      }
      additional_tags = {
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned",
        "k8s.io/cluster-autoscaler/enabled" = "TRUE"
      }
    }
  }

  #   map_roles    = var.map_roles
  map_users = var.map_users
  #   map_accounts = var.map_accounts
}