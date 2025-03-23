variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "tags" {
  type = map(string)
  default = {
    "terraform" = "true"
    "kubernetes" = "eks-argocd-devsecops"
  }
  description = "Tags to apply to all resources"
}