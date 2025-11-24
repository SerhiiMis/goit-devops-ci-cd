module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.12"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access = true

  manage_aws_auth_configmap = true

  access_config = {
    authentication_mode = "API_AND_CONFIG_MAP"
  }

  map_roles = [
    {
      rolearn  = "arn:aws:iam::085710281301:root" # ВАШ ROOT ARN
      username = "root"
      groups   = ["system:masters"]
    }
  ]

  eks_managed_node_groups = {
    lesson7_nodes = {
      ami_type       = "AL2_x86_64"
      disk_size      = 20
      
      instance_types = ["t3.small"]

      min_size     = 2
      desired_size = 2
      max_size     = 4
    }
  }

  cluster_addons = {
    vpc-cni    = { most_recent = true }
    kube-proxy = { most_recent = true }
    coredns    = { most_recent = true }
  }

  tags = {
    Module = "eks"
  }
}


