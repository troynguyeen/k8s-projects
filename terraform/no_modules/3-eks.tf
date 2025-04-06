# EKS Cluster
resource "aws_eks_cluster" "demo_eks_cluster" {
  name = var.eks_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.demo_eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id,
      aws_subnet.private_subnet_1.id,
      aws_subnet.private_subnet_2.id
    ]
  }

  tags = {
    Name = var.eks_name
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

# IAM role for EKS Cluster
resource "aws_iam_role" "demo_eks_cluster_role" {
  name = "demo-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo_eks_cluster_role.name
}

# EKS Access Entry
locals {
  iam_eksadmin_arn = "arn:aws:iam::${var.ACCOUNT_ID}:user/eks-admin"
  iam_iamadmin_arn = "arn:aws:iam::${var.ACCOUNT_ID}:user/iamadmin"
}

resource "aws_eks_access_entry" "eks_eksadmin_access_entry" {
  cluster_name  = aws_eks_cluster.demo_eks_cluster.name
  principal_arn = local.iam_eksadmin_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_eksadmin_access_policy" {
  cluster_name  = aws_eks_cluster.demo_eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.iam_eksadmin_arn

  access_scope {
    type       = "cluster"
    namespaces = []
  }

  depends_on = [
    aws_eks_cluster.demo_eks_cluster
  ]
}

resource "aws_eks_access_entry" "eks_iamadmin_access_entry" {
  cluster_name  = aws_eks_cluster.demo_eks_cluster.name
  principal_arn = local.iam_iamadmin_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_iamadmin_access_policy" {
  cluster_name  = aws_eks_cluster.demo_eks_cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.iam_iamadmin_arn

  access_scope {
    type       = "cluster"
    namespaces = []
  }

  depends_on = [
    aws_eks_cluster.demo_eks_cluster
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "eks_nodegroup_1" {
  cluster_name    = aws_eks_cluster.demo_eks_cluster.name
  node_group_name = "eks-nodegroup-1"
  node_role_arn   = aws_iam_role.demo_eks_nodegroup_role.arn
  subnet_ids      = [aws_subnet.private_subnet_1.id]
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "${var.eks_nodegroup_name}-1"
  }
}

resource "aws_eks_node_group" "eks_nodegroup_2" {
  cluster_name    = aws_eks_cluster.demo_eks_cluster.name
  node_group_name = "eks-nodegroup-2"
  node_role_arn   = aws_iam_role.demo_eks_nodegroup_role.arn
  subnet_ids      = aws_subnet.private_subnet_2[*].id
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = {
    Name = "${var.eks_nodegroup_name}-2"
  }
}

# IAM role for EKS Node Group
resource "aws_iam_role" "demo_eks_nodegroup_role" {
  name = "demo-eks-nodegroup-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo_eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo_eks_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo_eks_nodegroup_role.name
}