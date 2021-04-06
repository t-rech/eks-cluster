resource "aws_kms_key" "vault" {
  description             = "${local.vault_name} KMS"
}

locals {
  vault_name = "vault-${var.cluster_name}"
}

resource "aws_dynamodb_table" "vault_table" {
  name         = local.vault_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Path"
  range_key    = "Key"

  attribute {
    name = "Path"
    type = "S"
  }

  attribute {
    name = "Key"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

data "aws_iam_policy_document" "vault_table_access" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_dynamodb_table.vault_table.arn}"]

    actions = [
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:CreateTable",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:DescribeTable",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_kms_key.vault.arn}"]

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
    ]
  }
}

resource "aws_iam_policy" "vault_table_access" {
  name        = "${local.vault_name}-dynamodb-access"
  description = "This gives the ability to connect to Vault's DynamoDB table"

  policy = data.aws_iam_policy_document.vault_table_access.json
}

# resource "aws_iam_role_policy_attachment" "k8s_workers_nodes" {
#   role       = "${var.k8s_workers_iam_role_name}"
#   policy_arn = "${aws_iam_policy.vault_table_access.arn}"
# }

resource "aws_iam_user" "vault_service_account" {
  name = "${local.vault_name}-service-account"
}

resource "aws_iam_user_policy_attachment" "vault_policy_attachment" {
  user       = aws_iam_user.vault_service_account.name
  policy_arn = aws_iam_policy.vault_table_access.arn
}

resource "aws_iam_access_key" "vault_access_key" {
  user = aws_iam_user.vault_service_account.name
}

data "aws_caller_identity" "current" {}
