## create the IAM role for the EKS Cluster
resource "aws_iam_role" "iam_role_eks_cluster" {
  name               = "${var.region}-${var.project}-EKSCluster-role"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
   }
  ]
 }
POLICY

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-EKSCluster-role"
    },
  )
}


### Attaching the EKS-cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iam_role_eks_cluster.name

}
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.iam_role_eks_cluster.name

}

## Creating the EKS cluster
resource "aws_eks_cluster" "eks_cluster" {
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
  name     = "${var.region}-${var.project}-EKS-Cluster"
  role_arn = aws_iam_role.iam_role_eks_cluster.arn
  version  = var.eks_version


  # Adding VPC Configuration

  vpc_config { # Configure EKS with vpc and network settings 
    security_group_ids      = ["${aws_security_group.eks_cluster.id}"]
    subnet_ids              = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0", ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy,
  ]
  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-EKS-Cluster"
    },
  )
}

