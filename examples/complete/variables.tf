variable "name_prefix" {
  type        = string
  description = "Prefix used to make IAM names unique in the target account."
  default     = "example"
}

variable "environment" {
  type        = string
  description = "Environment tag applied to managed users."
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "Owner tag applied to managed users."
  default     = "platform-team"
}

variable "project_name" {
  type        = string
  description = "Existing project name used for the attached policy scope."
}

variable "ci_cd_login_password" {
  type        = string
  description = "Initial console password for the CI/CD user. Use a secret injection mechanism and rotate it after use."
  sensitive   = true
}

variable "access_key_status" {
  type        = string
  description = "Initial status of the CI/CD access key. Set inactive and apply before destroying the key."
  default     = "active"

  validation {
    condition     = contains(["active", "inactive"], var.access_key_status)
    error_message = "access_key_status must be active or inactive."
  }
}
