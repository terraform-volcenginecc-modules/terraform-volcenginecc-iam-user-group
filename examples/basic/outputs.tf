output "users" {
  description = "Users created by the basic example."
  value       = module.iam_user_group.users
}

output "groups" {
  description = "Groups created by the basic example."
  value       = module.iam_user_group.groups
}
