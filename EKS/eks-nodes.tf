# ## IAM role for the EKS nodes
resource "aws_iam_role" "eks_nodes_role" {
  name               = "${var.region}-${var.project}-EKSnode-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-EKSnode-role"
    },
  )
}


## Attaching the different policies to Node members
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name


}
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name

}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonElasticFileSystemFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
  role       = aws_iam_role.eks_nodes_role.name
}

## EKS Launch Template

locals {
  use_custom_launch_template = var.create_launch_template
}
resource "aws_launch_template" "eks-launch-template" {
  depends_on              = [aws_eks_cluster.eks_cluster]
  description             = "to use with ${var.project} EKS cluster"
  disable_api_termination = false
  name                    = "${var.region}-${var.project}-EKS-launch-template"
  instance_type           = var.instance_type_lt
  vpc_security_group_ids  = []



  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.volume_size
      volume_type = var.volume_type
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.tags,
      {
        Name = "${var.region}-${var.project}-EKS-launch-template"
      },
    )

  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      var.tags,
      {
        Name = "${var.region}-${var.project}-EKS-launch-template"
      },
    )
  }
}

## Create the EKS cluster node group
resource "aws_eks_node_group" "node_group" {

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.region}-${var.project}-nodegroup"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
  ami_type        = var.ami_type

  launch_template {
    id      = aws_launch_template.eks-launch-template.id
    version = "$Latest"
  }
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  timeouts {}

  update_config {
    max_unavailable = 1
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-nodegroup"
    },
  )
}