<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.19 |
| kubernetes | >= 2.0 |
| random | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |
| kubernetes | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| k8s-service | ./template |  |
| service-role | ./modules/service-role |  |

## Resources

| Name |
|------|
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/data-sources/region) |
| [kubernetes_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/2.0/docs/resources/service_account) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_region | n/a | `string` | n/a | yes |
| env | n/a | `string` | n/a | yes |
| health | n/a | `string` | n/a | yes |
| image | n/a | `string` | n/a | yes |
| port | n/a | `number` | n/a | yes |
| project | n/a | `string` | n/a | yes |
| service | n/a | `string` | n/a | yes |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->