# ---------------------------------------------------------------------------------------------------------------------
# AWS Cloudwatch
# ---------------------------------------------------------------------------------------------------------------------
module "aws_cw_logs" {
  source  = "jnonino/cloudwatch-logs/aws"
  version = "1.0.2"
  logs_path                   = local.jenkins_master_cloudwatch_log_path
  profile                     = var.profile
  region                      = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS Task Definition
# ---------------------------------------------------------------------------------------------------------------------
# Task Definition Template
data "template_file" "jenkins_master_td_template" {
  template = file(
    "${path.module}/files/tasks_definitions/jenkins_master_task_definition.json",
  )
  vars = {
    NAME                       = local.jenkins_master_container_name
    DOCKER_IMAGE_NAME          = "jnonino/jenkins-master"
    DOCKER_IMAGE_TAG           = "latest"
    CPU                        = local.jenkins_fargate_cpu_value
    MEMORY                     = local.jenkins_fargate_memory_value
    CLOUDWATCH_PATH            = module.aws_cw_logs.logs_path
    AWS_REGION                 = var.region
    JENKINS_CONTAINER_WEB_PORT = local.jenkins_container_web_port
    JENKINS_CONTAINER_SLV_PORT = local.jenkins_container_slave_port
  }
}

# Task Definition
resource "aws_ecs_task_definition" "jenkins_master_td" {
  family                   = "${var.name_preffix}-jenkins-master"
  container_definitions    = data.template_file.jenkins_master_td_template.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = local.jenkins_fargate_cpu_value
  memory                   = local.jenkins_fargate_memory_value
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ECS Service
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "jenkins_master_service" {
  name            = "${var.name_preffix}-jenkins-master"
  depends_on      = [aws_alb_listener.jenkins_master_web_listener]
  cluster         = aws_ecs_cluster.jenkins_cluster.id
  task_definition = aws_ecs_task_definition.jenkins_master_td.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_sg.id]
    subnets          = var.private_subnets_ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.jenkins_master_alb_tg.arn
    container_name   = local.jenkins_master_container_name
    container_port   = local.jenkins_container_web_port
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ALB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_alb" "jenkins_master_alb" {
  name            = "${var.name_preffix}-jenkins-master-alb"
  internal        = false
  subnets         = var.public_subnets_ids
  security_groups = [aws_security_group.alb_sg.id]
  tags = {
    Name = "${var.name_preffix}-jenkins-master-alb"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ALB Target Group
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_alb_target_group" "jenkins_master_alb_tg" {
  depends_on  = [aws_alb.jenkins_master_alb]
  name        = "${var.name_preffix}-jenkins-master-alb-tg"
  protocol    = "HTTP"
  port        = local.jenkins_container_web_port
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path = "/"
    port = local.jenkins_container_web_port
  }
  tags = {
    Name = "${var.name_preffix}-jenkins-master-alb-tg"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS ALB Listener
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_alb_listener" "jenkins_master_web_listener" {
  load_balancer_arn = aws_alb.jenkins_master_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.jenkins_master_alb_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "jenkins_master_slave_listener" {
  load_balancer_arn = aws_alb.jenkins_master_alb.arn
  port              = local.jenkins_container_slave_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.jenkins_master_alb_tg.arn
    type             = "forward"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Auto Scaling
# ---------------------------------------------------------------------------------------------------------------------
# CloudWatch Alarm CPU High
resource "aws_cloudwatch_metric_alarm" "jenkins_master_cpu_high" {
  alarm_name          = "${var.name_preffix}-jenkins-master-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "85"
  dimensions = {
    ClusterName = aws_ecs_cluster.jenkins_cluster.name
    ServiceName = aws_ecs_service.jenkins_master_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.jenkins_master_scale_up_policy.arn]
}

# CloudWatch Alarm CPU Low
resource "aws_cloudwatch_metric_alarm" "jenkins_master_cpu_low" {
  alarm_name          = "${var.name_preffix}-jenkins-master-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  dimensions = {
    ClusterName = aws_ecs_cluster.jenkins_cluster.name
    ServiceName = aws_ecs_service.jenkins_master_service.name
  }
  alarm_actions = [aws_appautoscaling_policy.jenkins_master_scale_down_policy.arn]
}

# Scaling Up Policy
resource "aws_appautoscaling_policy" "jenkins_master_scale_up_policy" {
  name               = "${var.name_preffix}-jenkins-master-scale-up-policy"
  depends_on         = [aws_appautoscaling_target.jenkins_master_scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.jenkins_cluster.name}/${aws_ecs_service.jenkins_master_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# Scaling Down Policy
resource "aws_appautoscaling_policy" "jenkins_master_scale_down_policy" {
  name               = "${var.name_preffix}-jenkins-master-scale-down-policy"
  depends_on         = [aws_appautoscaling_target.jenkins_master_scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.jenkins_cluster.name}/${aws_ecs_service.jenkins_master_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# Scaling Target
resource "aws_appautoscaling_target" "jenkins_master_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.jenkins_cluster.name}/${aws_ecs_service.jenkins_master_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
  min_capacity       = 1
  max_capacity       = 5
}

