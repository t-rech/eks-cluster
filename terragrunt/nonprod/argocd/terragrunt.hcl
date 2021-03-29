# terragrunt/nonprod/argocd/terragrunt.hcl
terraform {
  source = "../../../argocd"
}
terraform_version_constraint = "= 0.12.30"

inputs = {
    cluster_name = "eks-cluster"
    kube_service_name = "public-ingressgateway"
    kube_service_namespace = "istio-system"
    hosted_zone = "rech.app"
    service_subdomain = "argocd"
    region = "us-east-1"
}

dependencies {
  paths = ["../acme"]
}
