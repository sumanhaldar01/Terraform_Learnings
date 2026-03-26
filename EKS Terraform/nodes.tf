resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "eks-production-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  # Nodes go into private subnets
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
    aws_subnet.private_c.id,
  ]

  # Instance type — t3.medium is good for learning/small prod
  # Use m5.large or m5.xlarge for real production workloads
  instance_types = ["t3.medium"]

  # How many nodes to run
  scaling_config {
    desired_size = 2   # start with 2
    min_size     = 2   # never go below 2 (for HA)
    max_size     = 5   # cluster autoscaler can scale up to 5
  }

  # If you update instance_type or AMI, replace nodes one at a time
  # so there's no downtime
  update_config {
    max_unavailable = 1
  }

  # Tells Terraform: the node role and all 3 policy attachments
  # must exist before creating the node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_ecr_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
  ]

  tags = {
    Name        = "eks-production-node"
    Environment = "production"
  }
}