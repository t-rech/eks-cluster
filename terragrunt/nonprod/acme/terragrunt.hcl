# terragrunt/nonprod/acme/terragrunt.hcl
terraform {
  source = "../../../acme"
}
terraform_version_constraint = "= 0.12.30"

inputs = {
    region = "us-east-1"
}
