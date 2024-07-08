terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "prod_ci_role" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "prod_ci_policy" {
  name        = "${var.name}-policy"
  description = "Policy allowing assume role for ${var.name} role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource = aws_iam_role.prod_ci_role.arn
      }
    ]
  })
}

resource "aws_iam_group" "prod_ci_group" {
  name = "${var.name}-group"
}

resource "aws_iam_group_policy_attachment" "prod_ci_policy_attachment" {
  group      = aws_iam_group.prod_ci_group.name
  policy_arn = aws_iam_policy.prod_ci_policy.arn
}

resource "aws_iam_user" "prod_ci_user" {
  name = var.name
}

resource "aws_iam_group_membership" "prod_ci_user_group_membership" {
  name = "${var.name}-group-membership"
  users = [
    aws_iam_user.prod_ci_user.name
  ]
  group = aws_iam_group.prod_ci_group.name
}
