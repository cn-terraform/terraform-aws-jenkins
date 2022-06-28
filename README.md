# Jenkins Terraform Module for AWS #

This Terraform module deploys a Jenkins Master Server providing high availability and scalability.

[![](https://github.com/cn-terraform/terraform-aws-jenkins/workflows/terraform/badge.svg)](https://github.com/cn-terraform/terraform-aws-jenkins/actions?query=workflow%3Aterraform)
[![](https://img.shields.io/github/license/cn-terraform/terraform-aws-jenkins)](https://github.com/cn-terraform/terraform-aws-jenkins)
[![](https://img.shields.io/github/issues/cn-terraform/terraform-aws-jenkins)](https://github.com/cn-terraform/terraform-aws-jenkins)
[![](https://img.shields.io/github/issues-closed/cn-terraform/terraform-aws-jenkins)](https://github.com/cn-terraform/terraform-aws-jenkins)
[![](https://img.shields.io/github/languages/code-size/cn-terraform/terraform-aws-jenkins)](https://github.com/cn-terraform/terraform-aws-jenkins)
[![](https://img.shields.io/github/repo-size/cn-terraform/terraform-aws-jenkins)](https://github.com/cn-terraform/terraform-aws-jenkins)

## Usage

Check valid versions on:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-jenkins/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/jenkins/aws>

## Other modules that you may need to use this module

The Networking module:
* Github Releases: <https://github.com/cn-terraform/terraform-aws-networking/releases>
* Terraform Module Registry: <https://registry.terraform.io/modules/cn-terraform/networking/aws>

## Install pre commit hooks.

Pleas run this command right after cloning the repository.

        pre-commit install

For that you may need to install the folowwing tools:
* [Pre-commit](https://pre-commit.com/)
* [Terraform Docs](https://terraform-docs.io/)

In order to run all checks at any point run the following command:

        pre-commit run --all-files

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cw_logs"></a> [aws\_cw\_logs](#module\_aws\_cw\_logs) | cn-terraform/cloudwatch-logs/aws | 1.0.11 |
| <a name="module_ecs-cluster"></a> [ecs-cluster](#module\_ecs-cluster) | cn-terraform/ecs-cluster/aws | 1.0.10 |
| <a name="module_ecs-fargate-service"></a> [ecs-fargate-service](#module\_ecs-fargate-service) | cn-terraform/ecs-fargate-service/aws | 2.0.30 |
| <a name="module_td"></a> [td](#module\_td) | cn-terraform/ecs-fargate-task-definition/aws | 1.0.29 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.jenkins_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.jenkins_data_mount_targets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.jenkins_data_allow_nfs_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.jenkins_data_allow_nfs_access_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | If true a new KMS key will be created to encrypt the logs. Defaults true. If set to false a custom key can be used by setting the variable `log_group_kms_key_id` | `bool` | `false` | no |
| <a name="input_enable_autoscaling"></a> [enable\_autoscaling](#input\_enable\_autoscaling) | (Optional) If true, autoscaling alarms will be created. | `bool` | `true` | no |
| <a name="input_log_group_kms_key_id"></a> [log\_group\_kms\_key\_id](#input\_log\_group\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested. | `string` | `null` | no |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | (Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Default to 30 days. | `number` | `30` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for resources on AWS | `any` | n/a | yes |
| <a name="input_private_subnets_ids"></a> [private\_subnets\_ids](#input\_private\_subnets\_ids) | List of Private Subnets IDs | `list(any)` | n/a | yes |
| <a name="input_public_subnets_ids"></a> [public\_subnets\_ids](#input\_public\_subnets\_ids) | List of Public Subnets IDs | `list(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region the infrastructure is hosted in | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jenkins_master_alb_arn"></a> [jenkins\_master\_alb\_arn](#output\_jenkins\_master\_alb\_arn) | Jenkins Master Application Load Balancer ARN |
| <a name="output_jenkins_master_alb_arn_suffix"></a> [jenkins\_master\_alb\_arn\_suffix](#output\_jenkins\_master\_alb\_arn\_suffix) | Jenkins Master Application Load Balancer ARN Suffix |
| <a name="output_jenkins_master_alb_dns_name"></a> [jenkins\_master\_alb\_dns\_name](#output\_jenkins\_master\_alb\_dns\_name) | Jenkins Master Application Load Balancer DNS Name |
| <a name="output_jenkins_master_alb_id"></a> [jenkins\_master\_alb\_id](#output\_jenkins\_master\_alb\_id) | Jenkins Master Application Load Balancer ID |
| <a name="output_jenkins_master_alb_zone_id"></a> [jenkins\_master\_alb\_zone\_id](#output\_jenkins\_master\_alb\_zone\_id) | Jenkins Master Application Load Balancer Zone ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
