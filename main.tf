# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  profile = var.profile
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Cloudwatch Logs
# ---------------------------------------------------------------------------------------------------------------------
module aws_cw_logs {
  source    = "cn-terraform/cloudwatch-logs/aws"
  version   = "1.0.4"
  logs_path = "/ecs/service/${var.name_preffix}-jenkins-master"
  profile   = var.profile
  region    = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------
locals {
  container_name = "${var.name_preffix}-jenkins"
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = module.aws_cw_logs.logs_path
      "awslogs-stream-prefix" = "ecs"
    }
    secretOptions = null
  }
  healthcheck = {
    command     = [ "CMD-SHELL", "curl -f http://localhost:8080/login || exit 1" ]
    retries     = 3
    timeout     = 5
    interval    = 30
    startPeriod = 20
  }
  port_mappings = [
    {
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    },
    {
      containerPort = 50000
      hostPort      = 50000
      protocol      = "tcp"
    }
  ]
  volumes = [{
    name      = "jenkins_efs"
    host_path = null
    docker_volume_configuration = []
    efs_volume_configuration = [{
      file_system_id = aws_efs_file_system.jenkins_data.id
      root_directory = "/var/jenkins_home"
    }]
  }]
  mount_points = [
    {
      sourceVolume  = "jenkins_efs"
      containerPath = "/var/jenkins_home"
    }
  ]
}

variable "mount_points" {
  description = "(Optional) Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`"
  type = list(object({
    containerPath = string
    sourceVolume  = string
  }))
  default = null
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Cluster
# ---------------------------------------------------------------------------------------------------------------------
module ecs-cluster {
  source  = "cn-terraform/ecs-cluster/aws"
  version = "1.0.3"
  name    = "${var.name_preffix}-jenkins"
  profile = var.profile
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# EFS
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_efs_file_system" "jenkins_data" {
  creation_token = "${var.name_preffix}-jenkins-efs"
  tags = {
    Name = "${var.name_preffix}-jenkins-efs"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Task Definition
# ---------------------------------------------------------------------------------------------------------------------
module "td" {
  source  = "cn-terraform/ecs-fargate-task-definition/aws"
  version = "1.0.9"
  # source  = "../terraform-aws-ecs-fargate-task-definition"

  name_preffix      = "${var.name_preffix}-jenkins"
  profile           = var.profile
  region            = var.region
  container_name    = local.container_name
  container_image   = "cnservices/jenkins-master"
  container_cpu     = 2048 # 2 vCPU - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
  container_memory  = 4096 # 4 GB  - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs

  healthcheck       = local.healthcheck
  log_configuration = local.log_configuration
  port_mappings     = local.port_mappings
  volumes           = local.volumes
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Service
# ---------------------------------------------------------------------------------------------------------------------
# module ecs-fargate-service {
#   # source              = "cn-terraform/ecs-fargate-service/aws"
#   # version             = "1.0.10"
#   source              = "../terraform-aws-ecs-fargate-service"

#   name_preffix        = "${var.name_preffix}-jenkins"
#   profile             = var.profile
#   region              = var.region
#   vpc_id              = var.vpc_id
#   task_definition_arn = module.td.aws_ecs_task_definition_td_arn
#   container_name      = local.container_name
#   # container_port      = module.td.container_port
#   ecs_cluster_name    = module.ecs-cluster.aws_ecs_cluster_cluster_name
#   ecs_cluster_arn     = module.ecs-cluster.aws_ecs_cluster_cluster_arn
#   private_subnets     = var.private_subnets_ids
#   public_subnets      = var.public_subnets_ids

#   health_check_grace_period_seconds = 20
# }
