# Jenkins Terraform Module #

This Terraform module deploys a Jenkins Master Server providing high availability and scalability.

## Usage

This module deploys Jenkins on several cloud providers.

Amazon Web Services  

	module "jenkins" {
		source = "bitbucket.org/jnonino/terraform-module-jenkins//aws"
	}
	
Google Cloud Platform  

	module "jenkins" {
		source = "bitbucket.org/jnonino/terraform-module-jenkins//gcp"
	}

Microsoft Azure  

	module "jenkins" {
		source = "bitbucket.org/jnonino/terraform-module-jenkins//azure"
	}