output "custom_policies" {
  description = "Custom policies indexed by the input logical key."
  value = {
    for key, policy in volcenginecc_iam_policy.custom : key => {
      id          = policy.id
      policy_name = policy.policy_name
    }
  }
}

output "users" {
  description = "IAM users indexed by the input logical key."
  value = {
    for key, user in volcenginecc_iam_user.this : key => {
      id        = user.id
      user_name = user.user_name
    }
  }
}

output "groups" {
  description = "IAM groups indexed by the input logical key."
  value = {
    for key, group in volcenginecc_iam_group.this : key => {
      id              = group.id
      user_group_name = group.user_group_name
    }
  }
}

output "access_keys" {
  description = "Access-key identifiers and secret material indexed by the input logical key. Treat this output as sensitive."
  sensitive   = true
  value = {
    for key, access_key in volcenginecc_iam_accesskey.this : key => {
      access_key_id     = access_key.access_key_id
      secret_access_key = access_key.secret_access_key
      status            = access_key.status
      user_name         = access_key.user_name
    }
  }
}
