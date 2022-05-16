<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.15.0 |
| aws | >= 3.19 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/ecr_repository) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| env | n/a | `string` | n/a | yes |
| image\_tag\_mutability | The image tag mutability | `string` | `"MUTABLE"` | no |
| kms\_key | The kms key | `string` | `null` | no |
| project | n/a | `string` | n/a | yes |
| scan\_on\_push | The scan on push | `bool` | `true` | no |
| service | n/a | `string` | n/a | yes |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->