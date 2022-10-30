# Calling already Existing resources for reuse in our configurations.

## VPC 
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.vpc}"
  }
}

## Public Subnet
data "aws_subnet" "public_subnet" {
  tags = {
    Name = var.public_subnet
  }
}

/* ## Availability zones
data "aws_availability_zones" "available" {} */

/* ## Cluster Auth
data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.eks_cluster.id
} */