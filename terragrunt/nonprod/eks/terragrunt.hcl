# terragrunt/nonprod/eks/terragrunt.hcl
terraform {
  source = "../../../eks"
}
terraform_version_constraint = "= 0.12.30"

inputs = {
    environment = "nonprod"
    region = "us-east-1"
}
