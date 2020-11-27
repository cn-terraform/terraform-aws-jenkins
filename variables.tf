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
  type        = list
}

variable "private_subnets_ids" {
  description = "List of Private Subnets IDs"
  type        = list
}

#------------------------------------------------------------------------------
# AWS Autoscaling
#------------------------------------------------------------------------------
variable "enable_autoscaling" {
  description = "(Optional) If true, autoscaling alarms will be created."
  type        = bool
  default     = true
}