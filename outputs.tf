# ---------------------------------------------------------------------------------------------------------------------
# Jenkins Master ALB DNS
# ---------------------------------------------------------------------------------------------------------------------
output "jenkins_master_alb_id" {
  description = "Jenkins Master Application Load Balancer ID"
  value       = module.ecs-alb.aws_lb_lb_id
}

output "jenkins_master_alb_arn" {
  description = "Jenkins Master Application Load Balancer ARN"
  value       = module.ecs-alb.aws_lb_lb_arn
}

output "jenkins_master_alb_arn_suffix" {
  description = "Jenkins Master Application Load Balancer ARN Suffix"
  value       = module.ecs-alb.aws_lb_lb_arn_suffix
}

output "jenkins_master_alb_dns_name" {
  description = "Jenkins Master Application Load Balancer DNS Name"
  value       = module.ecs-alb.aws_lb_lb_dns_name
}

output "jenkins_master_alb_zone_id" {
  description = "Jenkins Master Application Load Balancer Zone ID"
  value       = module.ecs-alb.aws_lb_lb_zone_id
}
