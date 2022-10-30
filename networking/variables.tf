## Common Variables
variable "region" {
  description = "Region to create  resources"
  type        = string
}

variable "project" {
  description = "Name of project"
  type        = string
}

variable "tags" {
  description = "tags to be used on project"
  type        = map(any)
}


## Networking Variables
variable "vpc_cidr" {
  type        = string
  description = "The cidr block value for the project vpc"
}

variable "private_subnet_1_cidr" {
  description = "The cidr block value for private subnet 1"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "The cidr block value for private subnet 2"
  type        = string
}

variable "private_subnet_3_cidr" {
  description = "The cidr block value for private subnet 3"
  type        = string
}

variable "private_subnet_4_cidr" {
  description = "The cidr block value for private subnet 4"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "The cidr block value for public subnet 1"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "The cidr block value for public subnet 2"
  type        = string
}

variable "private_attach_subnet_1_cidr" {
  description = "The cidr block value for private attach subnet 1"
  type        = string
}

variable "private_attach_subnet_2_cidr" {
  description = "The cidr block value for private attach subnet 2"
  type        = string
}

variable "public_rtb_cidr" {
  description = "The cidr block value for public route table"
  type        = string
}

variable "private_rtb_cidr" {
  description = "The cidr block value for private route table"
  type        = string
}

variable "data_rtb_cidr" {
  description = "The cidr block value for data route table"
  type        = string
}

variable "tgw_id" {
  description = "Transit gateway to use"
  type        = string
}