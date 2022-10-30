## Common Variables
variable "region" {
  description = "Region to create  resources"
  type        = string
  default     = ""
}

variable "project" {
  description = "Name of project"
  type        = string
}

variable "tags" {
  description = "tags to be used on project"
  type        = map(any)
}

## Data Variables
variable "vpc" {
  description = "The VPC we are deploying the resources to"
  type = string
}

variable "public_subnet" {
  description = "The subnet we are deploying the resources to"
  type = string
  
}

## Cloud9 Variables
/* variable "cloud9_developers" {
  description = "cloud9 developers usernames"
  type        = map(string)
  default     = {}
}

variable "cloud9_devops" {
  description = "cloud9 devops usernames"
  type        = map(string)
  default     = {}
}
variable "devops_arn" {
  description = "ARN for use on cloud9 for devops"
  type        = string
 
}

variable "developer_arn" {
  description = "ARN for use on cloud9 for developers"
  type        = string
}

 */
