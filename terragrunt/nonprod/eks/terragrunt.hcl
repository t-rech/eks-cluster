# terragrunt/nonprod/eks/terragrunt.hcl
terraform {
  source = "../../../modules/eks"

  after_hook "after_hook" {
    commands     = ["apply"]
    execute      = ["bash","update_kube_config.sh"]
    run_on_error = true
  }
}
terraform_version_constraint = "= 0.12.30"

inputs = {
    environment = "nonprod"
    region = "us-east-1"
}
