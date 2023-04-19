#------------------------------------------------------------------------------
# Misc
#------------------------------------------------------------------------------
variable "name_prefix" {
  description = "Name prefix for resources on AWS"
}

#------------------------------------------------------------------------------
# AWS CREDENTIALS AND REGION
#------------------------------------------------------------------------------
variable "region" {
  description = "AWS Region the infrastructure is hosted in"
}

#------------------------------------------------------------------------------
# AWS Networking
#------------------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC"
}

variable "public_subnets_ids" {
  description = "List of Public Subnets IDs"
  type        = list(any)
}

variable "private_subnets_ids" {
  description = "List of Private Subnets IDs"
  type        = list(any)
}

variable "lb_waf_web_acl_arn" {
  description = "ARN of a WAFV2 to associate with the ALB"
  type        = string
  default     = ""
}

#------------------------------------------------------------------------------
# AWS Autoscaling
#------------------------------------------------------------------------------
variable "enable_autoscaling" {
  description = "(Optional) If true, autoscaling alarms will be created."
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# AWS ECS
#------------------------------------------------------------------------------
variable "container_image" {
  description = "Name of the docker image used for deploy jenkins"
  type        = string
  default     = "cnservices/jenkins-master"
}

#------------------------------------------------------------------------------
# AWS ECS Container Definition Variables
#------------------------------------------------------------------------------

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
variable "container_memory" {
  type        = number
  description = "(Optional) The amount of memory (in MiB) to allow the container to use. This is a hard limit, if the container attempts to exceed the container_memory, the container is killed. This field is optional for Fargate launch type and the total amount of container_memory of all containers in a task will need to be lower than the task memory value"
  default     = 4096 # 4 GB
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-task-defs
variable "container_cpu" {
  type        = number
  description = "(Optional) The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 2048 # 2 vCPU
}

#------------------------------------------------------------------------------
# CloudWatch logs
#------------------------------------------------------------------------------
variable "create_kms_key" {
  description = "If true a new KMS key will be created to encrypt the logs. Defaults true. If set to false a custom key can be used by setting the variable `log_group_kms_key_id`"
  type        = bool
  default     = false
}

variable "log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data. Please note, after the AWS KMS CMK is disassociated from the log group, AWS CloudWatch Logs stops encrypting newly ingested data for the log group. All previously ingested data remains encrypted, and AWS CloudWatch Logs requires permissions for the CMK whenever the encrypted data is requested."
  type        = string
  default     = null
}

variable "log_group_retention_in_days" {
  description = "(Optional) Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. Default to 30 days."
  type        = number
  default     = 30
}
