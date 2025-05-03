module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = var.eks_name
  cluster_version = var.eks_version

  bootstrap_self_managed_addons = true
  cluster_addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {}
  }

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  # EKS Managed Node Group(s)
  #   eks_managed_node_group_defaults = {
  #     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  #   }

  eks_managed_node_groups = {
    "${var.eks_nodegroup_name}-1" = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 10
      desired_size = 2

      tags = {
        Name = "${var.eks_nodegroup_name}-1"
      }
    }

    "${var.eks_nodegroup_name}-2" = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 5
      desired_size = 2
      
      tags = {
        Name = "${var.eks_nodegroup_name}-2"
      }
    }
  }

  access_entries = {
    # One access entry with a policy associated
    iamadmin = {
      principal_arn = "arn:aws:iam::${var.ACCOUNT_ID}:user/iamadmin"

      policy_associations = {
        example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Name = var.eks_name
  }
}