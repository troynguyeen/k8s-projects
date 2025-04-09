# EKS

output "eks_api_endpoint_from_module" {
  value       = module.eks.cluster_endpoint
  description = "EKS API Server Endpoint from EKS Module"
}

output "eks_cluster_name_from_module" {
  value       = module.eks.cluster_name
  description = "EKS Cluster Name from EKS Module"
}

output "eks_cluster_version_from_module" {
  value       = module.eks.cluster_version
  description = "EKS Cluster Version from EKS Module"
}

# VPC
data "aws_vpc" "vpc_module" {
  id = module.vpc.vpc_id
}

output "vpc_id" {
  value = data.aws_vpc.vpc_module.id
  description = "The ID of the VPC from VPC Modules"
}