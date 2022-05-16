<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.19 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.19 |
| null | n/a |
| tls | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| eks-cluster | ./modules/eks-cluster |  |
| eks-nodegroup | ./modules/eks-nodegroup |  |
| role | ./modules/iam-role |  |
| securitygroup-cluster | ./modules/vpc-securitygroup |  |

## Resources

| Name |
|------|
| [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/data-sources/ami) |
| [aws_iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/iam_instance_profile) |
| [aws_iam_openid_connect_provider](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/iam_openid_connect_provider) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/iam_role_policy_attachment) |
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/kms_key) |
| [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/launch_template) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/data-sources/region) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/resources/security_group_rule) |
| [aws_subnets](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/data-sources/subnets) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.19/docs/data-sources/vpc) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| capacity\_type | capacity type | `string` | `"SPOT"` | no |
| desired\_size | desired size | `number` | `2` | no |
| disk\_size | disk size | `number` | `20` | no |
| eks\_version | eks version | `string` | `"1.19"` | no |
| endpoint\_private\_access | endpoint private access | `bool` | `false` | no |
| endpoint\_public\_access | endpoint public access | `bool` | `true` | no |
| env | environment name | `string` | n/a | yes |
| instance\_types | instance type | `list(string)` | <pre>[<br>  "t3.medium",<br>  "t3a.medium"<br>]</pre> | no |
| max\_size | max size | `number` | `2` | no |
| min\_size | min size | `number` | `2` | no |
| policy\_arn | policies for the cluster | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",<br>  "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",<br>  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",<br>  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",<br>  "arn:aws:iam::aws:policy/AutoScalingFullAccess",<br>  "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",<br>  "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",<br>  "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"<br>]</pre> | no |
| project | project name | `string` | n/a | yes |
| service | service name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| eks-cluster | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->