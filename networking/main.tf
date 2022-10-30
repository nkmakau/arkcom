resource "aws_vpc" "project-vpc" {
  # checkov:skip=CKV_AWS_130: Ensure VPC subnets do not assign public IP by default
  cidr_block = var.vpc_cidr

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-VPC"
    },
  )
}
## Flow logging for VPC
/* resource "aws_cloudwatch_log_group" "vpc-logging" {
  # checkov:skip=CKV_AWS_158: Ensure that CloudWatch Log Group is encrypted by KMS

  name              = "${var.region}-${var.project}-vpc-logging"
  retention_in_days = 90
}

resource "aws_iam_role" "project-iam-role" {
  name               = "${var.region}-${var.project}-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "project-iam-role-policy" {
  name   = "${var.region}-${var.project}-iam-role-policy"
  role   = aws_iam_role.project-iam-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
} */
## VPC logs
/* resource "aws_flow_log" "project-vpc-flow-logs" {
  iam_role_arn    = aws_iam_role.project-iam-role.arn
  log_destination = aws_cloudwatch_log_group.vpc-logging.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.project-vpc.id
} */

## Restrict inbound and outbound rules on default Security group
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.project-vpc.id
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project-vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-IGW"
    },
  )
}
data "aws_availability_zones" "available" {}

# Private Subnets #
resource "aws_subnet" "private_subnet_1" {

  cidr_block              = var.private_subnet_1_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = merge(
    var.tags,
    {
      Name                                                             = "${var.region}-${var.project}-PrivateSubnet-1",
      "kubernetes.io/cluster/${var.region}-${var.project}-EKS-Cluster" = "shared",
      "kubernetes.io/role/internal-elb"                                = 1
    },
  )
}

resource "aws_subnet" "private_subnet_2" {
  cidr_block              = var.private_subnet_2_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = merge(
    var.tags,
    {
      Name                                                             = "${var.region}-${var.project}-PrivateSubnet-2",
      "kubernetes.io/cluster/${var.region}-${var.project}-EKS-Cluster" = "shared",
      "kubernetes.io/role/internal-elb"                                = 1
    },
  )
}

## Data Subnets
resource "aws_subnet" "private_subnet_3" {
  cidr_block              = var.private_subnet_3_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-DataPrivateSubnet-3"
    },
  )
}

resource "aws_subnet" "private_subnet_4" {
  cidr_block              = var.private_subnet_4_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-DataPrivateSubnet-4"
    },
  )
}

# Public Subnets #
resource "aws_subnet" "public_subnet_1" {
  # checkov:skip=CKV_AWS_130: Ensure VPC subnets do not assign public IP by default
  cidr_block              = var.public_subnet_1_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PublicSubnet-1"
    },
  )
}

resource "aws_subnet" "public_subnet_2" {
  # checkov:skip=CKV_AWS_130: Ensure VPC subnets do not assign public IP by default
  cidr_block              = var.public_subnet_2_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PublicSubnet-2"
    },
  )
}

## Private attach subnets
resource "aws_subnet" "private_attach_subnet_1" {
  cidr_block              = var.private_attach_subnet_1_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PrivateAttachSubnet01"
    },
  )
}
resource "aws_subnet" "private_attach_subnet_2" {
  cidr_block              = var.private_attach_subnet_2_cidr
  vpc_id                  = aws_vpc.project-vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]


  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PrivateAttachSubnet02"
    },
  )
}


# # Public Subnets Routing Tables & Associations #
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = var.public_rtb_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PublicSubnets-RouteTable"
    },
  )
}
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rtb.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rtb.id
}

## VPC attachment to Transit gateway
/* resource "aws_ec2_transit_gateway_vpc_attachment" "project_vpc_tgw_att" {
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.project-vpc.id
  subnet_ids         = [aws_subnet.private_attach_subnet_1.id, aws_subnet.private_attach_subnet_2.id]

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-vpc-tgw-att"
    },
  )
} */

# Creating an Elastic IP for the NAT Gateway!
resource "aws_eip" "nat_gw_eip" {
  vpc = true
}

## Nat gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-Nat-Gateway"
    },
  )
}

# Private subnet routing table and association
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = var.private_rtb_cidr
    gateway_id = aws_nat_gateway.nat_gateway.id

  }

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PrivateSubnets01-02-RouteTable"
    },
  )

}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rtb.id
}
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rtb.id
}

# Data subnets routing table and association
resource "aws_route_table" "data_rtb" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = var.data_rtb_cidr
    gateway_id = aws_nat_gateway.nat_gateway.id

  }

  tags = merge(
    var.tags,
    {
      Name = "${var.region}-${var.project}-PrivateSubnets01-02-RouteTable"
    },
  )
}
resource "aws_route_table_association" "private_subnet_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.data_rtb.id
}
resource "aws_route_table_association" "private_subnet_4" {
  subnet_id      = aws_subnet.private_subnet_4.id
  route_table_id = aws_route_table.data_rtb.id
}