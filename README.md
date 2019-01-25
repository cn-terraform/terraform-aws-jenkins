# Jenkins Terraform Module #

This Terraform module deploys a Jenkins Master Server providing high availability and scalability.

## Amazon Web Services

### Usage

	module "jenkins" {
	    source = "github.com/jnonino/jenkins-terraform-module//aws?ref=1.0.0"
        name_preffix        = "${var.name_preffix}"
        profile             = "${var.profile}"
        region              = "${var.region}"
        vpc_id              = "${module.networking.vpc_id}"
        public_subnets_ids  = [ "${module.networking.public_subnets_ids}" ]
        private_subnets_ids = [ "${module.networking.private_subnets_ids}" ]
    }

### Output values

* variable: description.
