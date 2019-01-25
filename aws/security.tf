# ---------------------------------------------------------------------------------------------------------------------
# AWS Security Groups - Control Access to ALB
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "alb_sg" {
    name        = "${var.name_preffix}-jenkins-master-alb-sg"
    description = "Control access to ALB"
    vpc_id      = "${var.vpc_id}"
    ingress {
        protocol    = "tcp"
        from_port   = "${local.jenkins_container_web_port}"
        to_port     = "${local.jenkins_container_web_port}"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol  = "-1"
        from_port = 0
        to_port   = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.name_preffix}-jenkins-master-alb-sg"
    }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS Security Groups - ECS Service
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "ecs_service" {
    name        = "${var.name_preffix}-jenkins-master-ecs-service-sg"
    description = "Allow egress from container"
    vpc_id      = "${var.vpc_id}"
    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags {
        Name = "${var.name_preffix}-jenkins-master-ecs-service-sg"
    }
}
