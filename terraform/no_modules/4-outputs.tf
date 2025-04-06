data "aws_eks_cluster" "demo_eks_cluster" {
  name = aws_eks_cluster.demo_eks_cluster.name
}

output "eks_api_endpoint" {
  value       = data.aws_eks_cluster.demo_eks_cluster.endpoint
  description = "EKS API Server Endpoint"
}

output "eks_cluster_name" {
  value       = data.aws_eks_cluster.demo_eks_cluster.name
  description = "EKS Cluster Name"
}

output "eks_cluster_version" {
  value       = data.aws_eks_cluster.demo_eks_cluster.version
  description = "EKS Cluster Version"
}