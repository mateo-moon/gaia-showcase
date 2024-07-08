output "role_arn" {
  description = "The ARN of the role"
  value       = aws_iam_role.prod_ci_role.arn
}

output "policy_arn" {
  description = "The ARN of the policy"
  value       = aws_iam_policy.prod_ci_policy.arn
}

output "group_name" {
  description = "The name of the group"
  value       = aws_iam_group.prod_ci_group.name
}

output "user_name" {
  description = "The name of the user"
  value       = aws_iam_user.prod_ci_user.name
}
