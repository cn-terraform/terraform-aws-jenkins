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

## Output values

* jenkins_master_alb_id: Jenkins Master Application Load Balancer ID.
* jenkins_master_alb_arn: Jenkins Master Application Load Balancer ARN.
* jenkins_master_alb_arn_suffix: Jenkins Master Application Load Balancer ARN Suffix.
* jenkins_master_alb_dns_name: Jenkins Master Application Load Balancer DNS Name.
* jenkins_master_alb_zone_id: Jenkins Master Application Load Balancer Zone ID.
