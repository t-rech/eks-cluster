# terragrunt/nonprod/istio/terragrunt.hcl
terraform {
  source = "../../../modules/istio"
}
terraform_version_constraint = "= 0.12.30"

inputs = {
    cluster_name = "eks-cluster"
    region = "us-east-1"
}

dependencies {
  paths = ["../eks"]
}