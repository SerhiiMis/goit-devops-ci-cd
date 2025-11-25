data "aws_caller_identity" "current" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.12"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access = true

  authentication_mode                  = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true
  
  cluster_addons = {
    vpc-cni    = { most_recent = true }
    kube-proxy = { most_recent = true }
    coredns    = { most_recent = true }
  }

  eks_managed_node_groups = {
    lesson7_nodes = {
      ami_type       = "AL2_x86_64"
      disk_size      = 20
      instance_types = ["t3.small"]
      min_size       = 2
      desired_size   = 2
      max_size       = 4
    }
  }
  
  access_entries = var.enable_admin_access ? {
    for arn in var.admin_iam_arns :
    replace(arn, ":", "-") => {
      principal_arn = arn
      policy_associations = {
        cluster_admin = {
          policy_arn  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
      kubernetes_groups = ["custom-admin-group"]
    }
  } : {}
  
  tags = {
    Module = "eks"
  }
}