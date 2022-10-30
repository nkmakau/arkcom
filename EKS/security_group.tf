# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = "${var.region}-${var.project}-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = data.aws_vpc.vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-custer-sg"
    },
  )
}

resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cloud9_inbound" {
  description              = "Allow cloud9 to communicate with the cluster"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = "sg-06c3e6bbe5bbd532c"
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 0
  type                     = "egress"
}

# EKS Node Security Group
resource "aws_security_group" "eks_nodes" {
  name        = "${var.region}-${var.project}-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = data.aws_vpc.vpc.id

  egress {
    description = "All out traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-nodes-sg"
    },
  )
}

resource "aws_security_group_rule" "nodes_internal" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 0
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 0
  type                     = "ingress"
}

