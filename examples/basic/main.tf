terraform {
  required_version = ">= 1.5.0"
}

module "iam_user_group" {
  source  = "terraform-volcenginecc-modules/iam-user-group/volcenginecc"
  version = "~> 1.0"

  custom_policies = {
    team_read_only = {
      policy_name = "${var.name_prefix}-team-read-only"
      description = "Read-only baseline for the application team."
      policy_document = jsonencode({
        Version = "1"
        Statement = [{
          Effect   = "Allow"
          Action   = ["iam:ListUsers", "iam:ListUserGroups"]
          Resource = ["*"]
        }]
      })
    }
  }

  users = {
    developer = {
      user_name    = "${var.name_prefix}-developer"
      display_name = "Application developer"
      description  = "Team member managed through the IAM user group module."
      tags = {
        environment = var.environment
        owner       = "application-team"
      }
    }
  }

  groups = {
    application_team = {
      user_group_name = "${var.name_prefix}-application-team"
      description     = "Application team with a least-privilege read-only policy."
      user_keys       = ["developer"]
      attached_policies = [{
        policy_name = "${var.name_prefix}-team-read-only"
        policy_type = "Custom"
        policy_scope = [{
          policy_scope_type = "Global"
        }]
      }]
    }
  }
}
