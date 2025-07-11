#------------------------------------------------------------------------------
# AWS Cloudwatch Logs
#------------------------------------------------------------------------------
module "aws_cw_logs" {
  source  = "cn-terraform/cloudwatch-logs/aws"
  version = "1.0.13"
  # source  = "../terraform-aws-cloudwatch-logs"

  create_kms_key              = var.create_kms_key
  log_group_kms_key_id        = var.log_group_kms_key_id
  log_group_retention_in_days = var.log_group_retention_in_days
  logs_path                   = "/ecs/service/${var.name_prefix}-jenkins-master"
}

#------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------
locals {
  container_name = "${var.name_prefix}-jenkins"
  healthcheck = {
    command     = ["CMD-SHELL", "curl -f http://localhost:8080 || exit 1"]
    retries     = 3
    timeout     = 5
    interval    = 30
    startPeriod = 120
  }
  td_port_mappings = [
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
  service_http_ports = {
    ui = {
      listener_port     = 80
      target_group_port = 8080
    },
    workers = {
      listener_port     = 50000
      target_group_port = 50000
    }
  }
  service_https_ports = {}
}

#------------------------------------------------------------------------------
# ECS Cluster
#------------------------------------------------------------------------------
module "ecs-cluster" {
  source  = "cn-terraform/ecs-cluster/aws"
  version = "1.0.12"
  # source  = "../terraform-aws-ecs-cluster"

  name = "${var.name_prefix}-jenkins"
}

#------------------------------------------------------------------------------
# EFS
#------------------------------------------------------------------------------
resource "aws_efs_file_system" "jenkins_data" {
  creation_token = "${var.name_prefix}-jenkins-efs"
  tags = {
    Name = "${var.name_prefix}-jenkins-efs"
  }
}
resource "aws_security_group" "jenkins_data_allow_nfs_access" {
  name        = "${var.name_prefix}-jenkins-efs-allow-nfs"
  description = "Allow NFS inbound traffic to EFS"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name_prefix}-jenkins-efs-allow-nfs"
  }
}

data "aws_subnet" "private_subnets" {
  count = length(var.private_subnets_ids)
  id    = element(var.private_subnets_ids, count.index)
}

resource "aws_security_group_rule" "jenkins_data_allow_nfs_access_rule" {
  security_group_id        = aws_security_group.jenkins_data_allow_nfs_access.id
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = module.ecs-fargate-service.ecs_tasks_sg_id
}

resource "aws_efs_mount_target" "jenkins_data_mount_targets" {
  count           = length(var.private_subnets_ids)
  file_system_id  = aws_efs_file_system.jenkins_data.id
  subnet_id       = element(var.private_subnets_ids, count.index)
  security_groups = [aws_security_group.jenkins_data_allow_nfs_access.id]
}

#------------------------------------------------------------------------------
# ECS Task Definition
#------------------------------------------------------------------------------
module "td" {
  source  = "cn-terraform/ecs-fargate-task-definition/aws"
  version = "1.0.38"
  # source  = "../terraform-aws-ecs-fargate-task-definition"

  name_prefix      = "${var.name_prefix}-jenkins"
  container_name   = local.container_name
  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  port_mappings    = local.td_port_mappings
  healthcheck      = local.healthcheck
  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = module.aws_cw_logs.logs_path
      "awslogs-stream-prefix" = "ecs"
    }
    secretOptions = null
  }
  volumes = [{
    name                        = "jenkins_efs"
    host_path                   = null
    docker_volume_configuration = []
    efs_volume_configuration = [{
      file_system_id          = aws_efs_file_system.jenkins_data.id
      root_directory          = "/"
      transit_encryption      = "DISABLED"
      transit_encryption_port = null
      authorization_config    = []
    }]
  }]
  mount_points = [
    {
      sourceVolume  = "jenkins_efs"
      containerPath = "/var/jenkins_home"
      readOnly      = false
    }
  ]
}

#------------------------------------------------------------------------------
# ECS Service
#------------------------------------------------------------------------------
module "ecs-fargate-service" {
  source  = "cn-terraform/ecs-fargate-service/aws"
  version = "2.0.48"
  # source  = "../terraform-aws-ecs-fargate-service"

  name_prefix                       = "${var.name_prefix}-jenkins"
  vpc_id                            = var.vpc_id
  ecs_cluster_arn                   = module.ecs-cluster.aws_ecs_cluster_cluster_arn
  health_check_grace_period_seconds = 120
  task_definition_arn               = module.td.aws_ecs_task_definition_td_arn
  public_subnets                    = var.public_subnets_ids
  private_subnets                   = var.private_subnets_ids
  container_name                    = local.container_name
  enable_autoscaling                = var.enable_autoscaling
  ecs_cluster_name                  = module.ecs-cluster.aws_ecs_cluster_cluster_name
  waf_web_acl_arn                   = var.lb_waf_web_acl_arn

  lb_http_ports  = local.service_http_ports
  lb_https_ports = local.service_https_ports
}
