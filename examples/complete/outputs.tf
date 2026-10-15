output "users" {
  description = "Users created by the complete example."
  value       = module.iam_user_group.users
}

output "groups" {
  description = "Groups created by the complete example."
  value       = module.iam_user_group.groups
}

output "access_keys" {
  description = "CI/CD access-key material. Store it immediately in an approved secret manager."
  sensitive   = true
  value       = module.iam_user_group.access_keys
}
