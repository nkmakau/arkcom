variable "tags" {
  description = "tags to be used on project"
  type        = map(any)
}

variable "region" {
  description = "Region used for project"
  type        = string
}

variable "project" {
  description = "project name"
  type        = string
}

## VPC data and Subnets
variable "vpc" {
  type        = string
  description = "VPC name to use"
}

variable "private_subnet1" {
  type        = string
  description = "private subnet1 name to use"
}

variable "private_subnet2" {
  type        = string
  description = "private subnet2 name to use"
}

## EKS 
variable "eks_version" {
  description = "The EKS version to use"
  type        = string
}

variable "ami_type" {
  description = "ami type to use"
  type        = string
}

variable "instance_type_lt" {
  description = "Instance type to use with EKS launch template"
  type        = string
}

variable "desired_size" {
  description = "Desired size of eks scaling"
  type        = number
}

variable "max_size" {
  description = "Max size for eks scaling"
  type        = number
}

variable "min_size" {
  description = "Min size for eks scaling"
  type        = number
}

variable "volume_size" {
  description = "Disk size to be used"
  type        = number
}

variable "volume_type" {
  description = "volume type to use"
  type        = string
}

variable "capacity_type" {
  description = "Recommended is ON_DEMAND"
  type        = string
}
variable "create_launch_template" {
  description = "Determines whether to create a launch template or not. If set to `false`, EKS will use its own default launch template"
  type        = bool
  default     = true
}