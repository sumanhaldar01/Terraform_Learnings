# After terraform apply, these values print in your terminal

output "cluster_name" {
  description = "The EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_version" {
  description = "Kubernetes version running"
  value       = aws_eks_cluster.main.version
}

output "update_kubeconfig_command" {
  description = "Run this command to connect kubectl to your cluster"
  value       = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.main.name}"
}