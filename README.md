# terraform-volcenginecc-iam-user-group

## Overview

Terraform module for managing Volcengine IAM USER GROUP resources with the `volcenginecc` provider. The caller owns provider authentication, region configuration, and external resources passed by ID.

## Usage

```hcl
module "iam_user_group" {
  source  = "terraform-volcenginecc-modules/iam-user-group/volcenginecc"
  version = "~> 1.0"

  # Set the required module inputs for your environment.
}
```

## Requirements

| Name | Version |
|---|---|
| Terraform | `>= 1.5.7` |
| OpenTofu | `>= 1.11.8` |

## Providers

| Name | Source |
|---|---|
| `volcenginecc` | `volcengine/volcenginecc` |

## Resources

| Name | Description |
|---|---|
| `volcenginecc_iam_policy` | Module-defined volcenginecc_iam_policy. |
| `volcenginecc_iam_user` | Module-defined volcenginecc_iam_user. |
| `volcenginecc_iam_group` | Module-defined volcenginecc_iam_group. |
| `volcenginecc_iam_accesskey` | Module-defined volcenginecc_iam_accesskey. |

## Inputs

| Name | Description |
|---|---|
| `custom_policies` | Module-defined custom_policies. |
| `users` | Module-defined users. |
| `login_passwords` | Module-defined login_passwords. |
| `groups` | Module-defined groups. |
| `access_keys` | Module-defined access_keys. |

## Outputs

| Name | Description |
|---|---|
| `custom_policies` | Module-defined custom_policies. |
| `users` | Module-defined users. |
| `groups` | Module-defined groups. |
| `access_keys` | Module-defined access_keys. |

## Examples

- `basic`: independently runnable basic configuration.
- `complete`: independently runnable complete configuration.

## Notes

- Configure credentials using supported provider mechanisms; do not put access keys in module files.
- Review replacement behavior and provider constraints before applying changes.
- Run `terraform plan` after apply and confirm that the second plan has no changes.
