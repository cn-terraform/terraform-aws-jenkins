# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  profile   = "${var.profile}"
  region    = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------------------------------------------------
locals {
    jenkins_master_container_name      = "jenkins_master"
    jenkins_master_cloudwatch_log_path = "/ecs/service/${var.name_preffix}-jenkins-master"
    jenkins_container_web_port         = 8080
    jenkins_container_slave_port       = 50000
    jenkins_fargate_cpu_value          = 2048 # 2 vCPU  - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
    jenkins_fargate_memory_value       = 4096 # 4 GB    - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
}
