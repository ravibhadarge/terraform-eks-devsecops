data "aws_caller_identity" "current" {}

locals {
  oidc_provider = var.oidc_provider
}

resource "aws_iam_role" "this" {
  name = "${var.cluster_name}-${var.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${local.oidc_provider}:aud" = "sts.amazonaws.com"
          "${local.oidc_provider}:sub" = var.service_account
        }
      }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "this" {
  count = var.policy_json != "" ? 1 : 0
  name  = "${var.cluster_name}-${var.name}-policy"
  role  = aws_iam_role.this.id

  policy = var.policy_json
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  policy_arn = each.value
  role       = aws_iam_role.this.name
}
