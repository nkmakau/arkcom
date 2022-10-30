# Calling already Existing resources for reuse in our configurations.

## VPC 
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.vpc}"
  }
}

## Private Subnets
data "aws_subnet" "private_subnet1" {
  tags = {
    Name = var.private_subnet1
  }
}

data "aws_subnet" "private_subnet2" {
  tags = {
    Name = var.private_subnet2
  }
}

/* ## Public Subnet
data "aws_subnet" "public_subnet" {
  tags = {
    Name = var.public_subnet
  }
} */

## Availability zones
data "aws_availability_zones" "available" {}

## K8

/* data "aws_efs_file_system" "project_efs" {
  creation_token = "${var.region}-${var.project}-${var.efs_name}"
} */

/* data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.eks_cluster.id
} */

/* data "aws_security_group" "cloud9_sg" {
  tags = {
   Name = "aws-cloud9-eu-west-1-arkcom-kenya-nkmakau-cloud9-5540a433863d4c238f53577802778ffc-InstanceSecurityGroup-1A3GSK9I510V6"
  }
} */