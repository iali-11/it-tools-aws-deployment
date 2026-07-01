output "GitHub_Actions_OIDC_Role" {
  value = aws_iam_role.github_actions.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.it_tools_repo.repository_url
}