variable "custom_policies" {
  type = map(object({
    policy_name     = string
    policy_document = string
    description     = optional(string, "")
  }))
  description = "Custom IAM policies keyed by a stable logical key. Changing a key changes the Terraform resource address."
  default     = {}

  validation {
    condition = alltrue([
      for policy in values(var.custom_policies) : length(trimspace(policy.policy_name)) > 0 && can(jsondecode(policy.policy_document))
    ])
    error_message = "Each custom policy requires a non-empty policy_name and a valid JSON policy_document."
  }
}

variable "users" {
  type = map(object({
    user_name    = string
    description  = optional(string, "")
    display_name = optional(string, "")
    email        = optional(string, "")
    login_profile = optional(object({
      login_allowed             = optional(bool)
      password_reset_required   = optional(bool)
      safe_auth_exempt_duration = optional(number)
      safe_auth_exempt_required = optional(number)
      safe_auth_exempt_unit     = optional(number)
      safe_auth_flag            = optional(bool)
      safe_auth_type            = optional(string)
    }))
    tags = optional(map(string), {})
  }))
  description = "IAM users keyed by a stable logical key. Supply login passwords through login_passwords. Group membership and policy attachments are intentionally managed through groups, not this input."
  default     = {}

  validation {
    condition     = alltrue([for user in values(var.users) : length(trimspace(user.user_name)) > 0])
    error_message = "Each user must have a non-empty user_name."
  }
}

variable "login_passwords" {
  type        = map(string)
  description = "Initial console passwords keyed by users logical key. Passwords are passed only to matching users with a login profile."
  default     = {}
  sensitive   = true
}

variable "groups" {
  type = map(object({
    user_group_name = string
    description     = optional(string, "")
    display_name    = optional(string, "")
    user_keys       = optional(set(string), [])
    user_names      = optional(set(string), [])
    attached_policies = optional(list(object({
      policy_name = string
      policy_type = string
      policy_scope = optional(list(object({
        policy_scope_type = string
        project_name      = optional(string)
      })), [])
    })), [])
  }))
  description = "IAM groups keyed by a stable logical key. Each group exclusively owns its listed members and attached policies."
  default     = {}

  validation {
    condition     = alltrue([for group in values(var.groups) : length(trimspace(group.user_group_name)) > 0])
    error_message = "Each group must have a non-empty user_group_name."
  }

  validation {
    condition = alltrue(flatten([
      for group in values(var.groups) : [
        for policy in group.attached_policies : contains(["System", "Custom"], policy.policy_type) && length(trimspace(policy.policy_name)) > 0
      ]
    ]))
    error_message = "Attached policies require a non-empty name and policy_type of System or Custom."
  }

  validation {
    condition = alltrue(flatten([
      for group in values(var.groups) : [
        for policy in group.attached_policies : [
          for scope in policy.policy_scope :
          contains(["Global", "Project"], scope.policy_scope_type) &&
          (scope.policy_scope_type != "Project" ? true : (scope.project_name != null && length(trimspace(scope.project_name)) > 0))
        ]
      ]
    ]))
    error_message = "Policy scopes must be Global or Project; Project scope requires project_name."
  }
}

variable "access_keys" {
  type = map(object({
    user_key = string
    status   = optional(string, "active")
  }))
  description = "Access keys keyed by a stable logical key. user_key must reference a key in users."
  default     = {}

  validation {
    condition     = alltrue([for key in values(var.access_keys) : contains(["active", "inactive"], key.status)])
    error_message = "Each access key status must be active or inactive."
  }
}
