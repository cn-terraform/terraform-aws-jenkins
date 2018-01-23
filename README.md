# Jenkins Terraform Module #

This Terraform module deploys a Jenkins Master Server providing high availability and scalability.

## Usage

This module deploys Jenkins on several cloud providers.

Amazon Web Services - PENDING  

	module "jenkins" {
		source = "github.com/jnonino/jenkins-terraform-module//aws"
	}
	
Google Cloud Platform - PENDING  

	module "jenkins" {
		source = "github.com/jnonino/jenkins-terraform-module//gcp"
	}

Microsoft Azure - PENDING  

	module "jenkins" {
		source = "github.com/jnonino/jenkins-terraform-module//azure"
	}
