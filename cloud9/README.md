### PCI-DSS INFRASTRUCTURE (BUILD WITH TERRAFORM)
The project looks at creating new infrastucture for PCI-DSS.  Clou9




<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.30.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloud9_environment_ec2.cloud9_developers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2) | resource |
| [aws_cloud9_environment_ec2.cloud9_devops](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud9_developers"></a> [cloud9\_developers](#input\_cloud9\_developers) | cloud9 developers usernames | `map(string)` | `{}` | no |
| <a name="input_cloud9_devops"></a> [cloud9\_devops](#input\_cloud9\_devops) | cloud9 devops usernames | `map(string)` | `{}` | no |
| <a name="input_developer_arn"></a> [developer\_arn](#input\_developer\_arn) | ARN for use on cloud9 for developers | `string` | `""` | no |
| <a name="input_devops_arn"></a> [devops\_arn](#input\_devops\_arn) | ARN for use on cloud9 for devops | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | Name of project | `string` | n/a | yes |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | The subnet we are deploying the resources to | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to create  resources | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be used on project | `map(any)` | n/a | yes |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | The VPC we are deploying the resources to | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->