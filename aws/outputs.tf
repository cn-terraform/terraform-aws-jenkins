# ---------------------------------------------------------------------------------------------------------------------
# Jenkins Master ALB DNS
# ---------------------------------------------------------------------------------------------------------------------
output "jenkins_master_alb_id" {
  value = "${aws_alb.jenkins_master_alb.id}"
}
output "jenkins_master_alb_arn" {
  value = "${aws_alb.jenkins_master_alb.arn}"
}
output "jenkins_master_alb_arn_suffix" {
  value = "${aws_alb.jenkins_master_alb.arn_suffix}"
}
output "jenkins_master_alb_dns_name" {
  value = "${aws_alb.jenkins_master_alb.dns_name}"
}
output "jenkins_master_alb_zone_id" {
  value = "${aws_alb.jenkins_master_alb.zone_id}"
}
