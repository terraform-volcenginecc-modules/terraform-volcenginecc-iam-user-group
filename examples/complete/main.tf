terraform {
  required_version = ">= 1.5.0"
}

module "iam_user_group" {
  source  = "terraform-volcenginecc-modules/iam-user-group/volcenginecc"
  version = "~> 1.0"

  custom_policies = {
    project_observer = {
      policy_name = "${var.name_prefix}-project-observer"
      description = "Least-privilege policy for project-scoped observation."
      policy_document = jsonencode({
        Version = "1"
        Statement = [{
          Effect   = "Allow"
          Action   = ["ecs:Describe*", "vpc:Describe*"]
          Resource = ["*"]
        }]
      })
    }
  }

  users = {
    team_member = {
      user_name    = "${var.name_prefix}-team-member"
      display_name = "Team member"
      description  = "Interactive team identity."
      tags = {
        environment = var.environment
        identity    = "human"
        owner       = var.owner
      }
    }

    ci_cd = {
      user_name    = "${var.name_prefix}-ci-cd"
      display_name = "CI CD account"
      description  = "Automation identity with a managed access key."
      login_profile = {
        login_allowed           = true
        password_reset_required = true
      }
      tags = {
        environment = var.environment
        identity    = "automation"
        owner       = var.owner
      }
    }
  }

  login_passwords = {
    ci_cd = var.ci_cd_login_password
  }

  groups = {
    project_observers = {
      user_group_name = "${var.name_prefix}-project-observers"
      description     = "Project-scoped observers."
      user_keys       = ["team_member", "ci_cd"]
      attached_policies = [{
        policy_name = "${var.name_prefix}-project-observer"
        policy_type = "Custom"
        policy_scope = [{
          policy_scope_type = "Project"
          project_name      = var.project_name
        }]
      }]
    }
  }

  access_keys = {
    ci_cd = {
      user_key = "ci_cd"
      status   = var.access_key_status
    }
  }
}
