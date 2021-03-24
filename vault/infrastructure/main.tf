resource "aws_kms_key" "vault" {
  description             = "${local.vault_name} KMS"
  deletion_window_in_days = 10
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

resource "aws_iam_policy" "vault_table_access" {
  name        = "${local.vault_name}-dynamodb-access"
  description = "This gives the ability to connect to Vault's DynamoDB table"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
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
        "dynamodb:DescribeTable"
      ],
      "Resource": ["${aws_dynamodb_table.vault_table.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:DescribeKey",
        "kms:Encrypt"
      ],
      "Resource": "${aws_kms_key.vault.arn}"
    }
  ]
}
POLICY
}

# resource "aws_iam_role_policy_attachment" "k8s_workers_nodes" {
#   role       = "${var.k8s_workers_iam_role_name}"
#   policy_arn = "${aws_iam_policy.vault_table_access.arn}"
# }

resource "aws_iam_user" "aws_secret_engine" {
  name = "${local.vault_name}-service-account"
}

resource "aws_iam_access_key" "vault_access_key" {
  user = aws_iam_user.aws_secret_engine.name
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user_policy" "aws_secret_engine" {
  name = "${local.vault_name}-aws-secret-engine"
  user = aws_iam_user.aws_secret_engine.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/vault-*"
      ]
    }
  ]
}
EOF
}
