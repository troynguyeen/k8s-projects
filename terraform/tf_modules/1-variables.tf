variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "eks_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "demo-eks-cluster"
}

variable "eks_version" {
  description = "EKS Cluster Version"
  type        = string
  default     = "1.32"
}

variable "eks_nodegroup_name" {
  description = "EKS Node Group Name"
  type        = string
  default     = "demo-eks-nodegroup"
}

variable "ACCOUNT_ID" {
  description = "AWS Account ID"
  type        = string
}

# variable "iam_iamadmin_arn" {
#   description = "IAM User ARN to grant to EKS Access Entry"
#   type        = string
#   default     = "arn:aws:iam::${var.ACCOUNT_ID}:user/eks-admin"
#   ephemeral = true
# }

# variable "iam_eksadmin_arn" {
#   description = "IAM User ARN to grant to EKS Access Entry"
#   type        = string
#   default     = "arn:aws:iam::${var.ACCOUNT_ID}:user/eks-admin"
#   ephemeral = true
# }