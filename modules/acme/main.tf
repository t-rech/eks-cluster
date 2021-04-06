locals {
  cert_manager_name = "cert-manager-${var.cluster_name}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::change/*"]
    actions   = ["route53:GetChange"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:route53:::hostedzone/*"]

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["route53:ListHostedZonesByName"]
  }
}

resource "aws_iam_policy" "route53_access" {
  name        = "${local.cert_manager_name}-route53-access"
  description = "This gives the ability to Cert Manager add let's encrypt routes to solve DNS challenge"

  policy = data.aws_iam_policy_document.policy.json
}


resource "aws_iam_user" "cert_manager_service_account" {
  name = "${local.cert_manager_name}-service-account"
}

resource "aws_iam_user_policy_attachment" "cert_manager_policy_attachment" {
  user       = aws_iam_user.cert_manager_service_account.name
  policy_arn = aws_iam_policy.route53_access.arn
}

resource "aws_iam_access_key" "cert_manager_access_key" {
  user = aws_iam_user.cert_manager_service_account.name
}
