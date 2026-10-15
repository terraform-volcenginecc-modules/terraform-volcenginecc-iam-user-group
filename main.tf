resource "volcenginecc_iam_policy" "custom" {
  for_each = var.custom_policies

  policy_name     = each.value.policy_name
  policy_document = each.value.policy_document
  policy_type     = "Custom"
  description     = each.value.description
}

resource "volcenginecc_iam_user" "this" {
  for_each = var.users

  user_name    = each.value.user_name
  description  = each.value.description
  display_name = each.value.display_name
  email        = each.value.email
  login_profile = each.value.login_profile == null ? null : merge(each.value.login_profile, {
    password = try(var.login_passwords[each.key], null)
  })
  tags = toset([
    for key, value in each.value.tags : {
      key   = key
      value = value
    }
  ])

  lifecycle {
    precondition {
      condition     = each.value.login_profile == null || try(each.value.login_profile.login_allowed, false) == false || contains(nonsensitive(keys(var.login_passwords)), each.key)
      error_message = "A login profile with login_allowed set to true requires a password in login_passwords under the same user key."
    }
  }
}

resource "volcenginecc_iam_group" "this" {
  for_each = var.groups

  depends_on = [volcenginecc_iam_policy.custom]

  user_group_name = each.value.user_group_name
  description     = each.value.description
  display_name    = each.value.display_name
  users = toset([
    for user_name in distinct(concat(
      tolist(each.value.user_names),
      [for user_key in each.value.user_keys : volcenginecc_iam_user.this[user_key].user_name],
      )) : {
      user_name = user_name
    }
  ])
  attached_policies = toset([
    for policy in each.value.attached_policies : {
      policy_name = policy.policy_name
      policy_type = policy.policy_type
      policy_scope = toset([
        for scope in policy.policy_scope : {
          policy_scope_type = scope.policy_scope_type
          project_name      = try(scope.project_name, null)
        }
      ])
    }
  ])

  lifecycle {
    precondition {
      condition     = alltrue([for user_key in each.value.user_keys : contains(keys(var.users), user_key)])
      error_message = "Every groups[*].user_keys entry must reference a key in users."
    }
  }
}

resource "volcenginecc_iam_accesskey" "this" {
  for_each = var.access_keys

  user_name = volcenginecc_iam_user.this[each.value.user_key].user_name
  status    = each.value.status

  lifecycle {
    precondition {
      condition     = contains(keys(var.users), each.value.user_key)
      error_message = "Every access_keys[*].user_key entry must reference a key in users."
    }
  }
}
