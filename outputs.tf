# ---------------------------------------------------------------------------------------------------------------------
# Jenkins Master ALB DNS
# ---------------------------------------------------------------------------------------------------------------------
output "jenkins_master_alb_id" {
  description = "Jenkins Master Application Load Balancer ID"
  value = "${aws_alb.jenkins_master_alb.id}"
}
output "jenkins_master_alb_arn" {
  description = "Jenkins Master Application Load Balancer ARN"
  value = "${aws_alb.jenkins_master_alb.arn}"
}
output "jenkins_master_alb_arn_suffix" {
  description = "Jenkins Master Application Load Balancer ARN Suffix"
  value = "${aws_alb.jenkins_master_alb.arn_suffix}"
}
output "jenkins_master_alb_dns_name" {
  description = "Jenkins Master Application Load Balancer DNS Name"
  value = "${aws_alb.jenkins_master_alb.dns_name}"
}
output "jenkins_master_alb_zone_id" {
  description = "Jenkins Master Application Load Balancer Zone ID"
  value = "${aws_alb.jenkins_master_alb.zone_id}"
}
