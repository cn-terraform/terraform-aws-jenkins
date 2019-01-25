# Jenkins Terraform Module #

This Terraform module deploys a Jenkins Master Server providing high availability and scalability.

## Amazon Web Services

### Usage

	module "jenkins" {
		source = "github.com/jnonino/jenkins-terraform-module//aws?ref=1.0.0"
	}

### Output values

* variable: description.
