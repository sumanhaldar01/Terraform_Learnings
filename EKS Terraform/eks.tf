resource "aws_eks_cluster" "main" {
  name    = "eks-production"
  version = "1.31"   # always pin to a specific version, never leave blank

  # The cluster role we created in iam.tf
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    # Worker nodes will run in private subnets
    subnet_ids = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id,
      aws_subnet.private_c.id,
    ]

    # false = Kubernetes API is only reachable from inside the VPC
    # true  = Kubernetes API is reachable from the internet (needed for kubectl from your laptop)
    # For production: set endpoint_public_access = false and use a bastion or VPN
    # For learning: true is fine
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  # Tells Terraform: the cluster role and its policy attachments
  # must exist before creating the cluster
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]

  tags = {
    Name        = "eks-production"
    Environment = "production"
  }
}
