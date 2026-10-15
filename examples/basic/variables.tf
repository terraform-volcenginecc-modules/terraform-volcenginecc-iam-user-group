variable "name_prefix" {
  type        = string
  description = "Prefix used to make IAM names unique in the target account."
  default     = "example"
}

variable "environment" {
  type        = string
  description = "Environment tag applied to the example user."
  default     = "dev"
}
