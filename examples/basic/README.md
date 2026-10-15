# BASIC IAM USER GROUP Example

## Overview

Runnable basic configuration for the IAM USER GROUP module. It configures the provider from input variables and calls the published Registry module.

## Usage

```shell
terraform init
terraform plan
terraform apply
terraform plan
terraform destroy
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
| `terraform-volcenginecc-modules/iam-user-group/volcenginecc` | Published IAM USER GROUP module. |

## Inputs

| Name | Description |
|---|---|
| `name_prefix` | Module-defined name_prefix. |
| `environment` | Module-defined environment. |

## Outputs

| Name | Description |
|---|---|
| `users` | Module-defined users. |
| `groups` | Module-defined groups. |

## Examples

This directory is the basic example.

## Notes

- Supply credentials through supported provider configuration, never in source files.
- The final plan after apply must report no changes before the configuration is accepted.
