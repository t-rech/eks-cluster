# terragrunt/nonprod/vault/terragrunt.hcl
terraform {
  source = "../../../modules/vault/infrastructure"
}
terraform_version_constraint = "= 0.12.30"

inputs = {
    region = "us-east-1"
    cluster_name = "eks-cluster"
}

dependencies {
  paths = ["../eks"]
}