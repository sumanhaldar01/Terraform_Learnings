# ─── ROLE 1: EKS CLUSTER ROLE ───────────────────────────────────────
# This role is assumed by the EKS control plane (AWS managed)
# It allows AWS to manage networking, load balancers on your behalf

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

  # Trust policy — who can assume this role
  # Here we say: the EKS service itself can assume it
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = { Name = "eks-cluster-role" }
}

# Attach the AWS managed policy — gives EKS permissions to
# manage ENIs, security groups, load balancers for the cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# ─── ROLE 2: EKS NODE ROLE ──────────────────────────────────────────
# This role is assumed by the EC2 worker nodes
# Nodes need to pull images from ECR, register with the cluster,
# and read VPC networking info

resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-role"

  # Trust policy — EC2 instances (the nodes) can assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = { Name = "eks-node-role" }
}

# Policy 1 — allows the node to register itself with the EKS cluster
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

# Policy 2 — allows the node to pull Docker images from ECR
resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# Policy 3 — allows the node to read VPC and subnet info for networking (CNI plugin)
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}