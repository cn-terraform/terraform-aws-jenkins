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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 3.74.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.74.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_cw_logs"></a> [aws\_cw\_logs](#module\_aws\_cw\_logs) | cn-terraform/cloudwatch-logs/aws | 1.0.8 |
| <a name="module_ecs-cluster"></a> [ecs-cluster](#module\_ecs-cluster) | cn-terraform/ecs-cluster/aws | 1.0.7 |
| <a name="module_ecs-fargate-service"></a> [ecs-fargate-service](#module\_ecs-fargate-service) | cn-terraform/ecs-fargate-service/aws | 2.0.18 |
| <a name="module_td"></a> [td](#module\_td) | cn-terraform/ecs-fargate-task-definition/aws | 1.0.24 |

## Resources

| Name | Type |
|------|------|
| [aws_efs_file_system.jenkins_data](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.jenkins_data_mount_targets](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/efs_mount_target) | resource |
| [aws_security_group.jenkins_data_allow_nfs_access](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/security_group) | resource |
| [aws_security_group_rule.jenkins_data_allow_nfs_access_rule](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/security_group_rule) | resource |
| [aws_subnet.private_subnets](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_autoscaling"></a> [enable\_autoscaling](#input\_enable\_autoscaling) | (Optional) If true, autoscaling alarms will be created. | `bool` | `true` | no |
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
