# The VPC — your private network in AWS
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true   # required for EKS nodes to resolve AWS endpoints
  enable_dns_support   = true

  tags = {
    Name = "eks-vpc"
  }
}

# Internet Gateway — allows public subnets to reach the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "eks-igw"
  }
}

# ----- PUBLIC SUBNETS (one per AZ) -----
# EKS puts load balancers here
# The kubernetes.io tags tell EKS which subnets to use for ALBs

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true   # instances here get a public IP

  tags = {
    Name                                    = "eks-public-a"
    "kubernetes.io/role/elb"                = "1"   # marks this for public load balancers
    "kubernetes.io/cluster/eks-production"  = "shared"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "eks-public-b"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/eks-production"  = "shared"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name                                    = "eks-public-c"
    "kubernetes.io/role/elb"                = "1"
    "kubernetes.io/cluster/eks-production"  = "shared"
  }
}

# ----- PRIVATE SUBNETS (one per AZ) -----
# Worker nodes live here — no direct internet exposure

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name                                        = "eks-private-a"
    "kubernetes.io/role/internal-elb"           = "1"   # marks for internal load balancers
    "kubernetes.io/cluster/eks-production"      = "shared"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name                                        = "eks-private-b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/eks-production"      = "shared"
  }
}

resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name                                        = "eks-private-c"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/eks-production"      = "shared"
  }
}

# ----- NAT GATEWAY -----
# Allows private subnet nodes to pull images, download packages
# WITHOUT being exposed to the internet inbound
# One NAT per AZ = HA but costs more. One NAT total = cheaper but single point of failure.
# For production: one per AZ. For learning/cost saving: one is fine.

resource "aws_eip" "nat" {
  domain = "vpc"   # required for NAT gateway EIPs
  tags   = { Name = "eks-nat-eip" }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id   # NAT gateway sits in a PUBLIC subnet

  tags = { Name = "eks-nat" }

  depends_on = [aws_internet_gateway.main]
}

# ----- ROUTE TABLES -----
# Public route table: sends 0.0.0.0/0 to Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "eks-public-rt" }
}

# Associate the public route table with all public subnets
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

# Private route table: sends 0.0.0.0/0 to NAT Gateway (outbound only)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = { Name = "eks-private-rt" }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.private.id
}