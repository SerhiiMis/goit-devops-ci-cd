terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "lesson-8-9-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "django-app-repo"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnets
}

module "rds" {
    source             = "./modules/rds"
    vpc_id             = module.vpc.vpc_id
    private_subnet_ids = module.vpc.private_subnets 
    master_password    = random_password.db_master.result
    
}

module "monitoring" {
  source = "./modules/monitoring"
  cluster_name = module.eks.cluster_name
  eks_host     = module.eks.cluster_endpoint
  eks_ca_cert  = module.eks.cluster_certificate_authority_data
  
  depends_on = [
    module.eks, 
  ]
}

# resource "aws_eks_addon" "ebs_csi_driver_external" {
#   cluster_name                = module.eks.cluster_name
#   addon_name                  = "aws-ebs-csi-driver"
#   service_account_role_arn    = module.eks.ebs_csi_driver_role_arn
#   resolve_conflicts_on_create = "OVERWRITE"
#   resolve_conflicts_on_update = "OVERWRITE"
#   depends_on                  = [module.eks]
# }

module "jenkins" {
  source             = "./modules/jenkins"
  eks_host           = module.eks.cluster_endpoint
  eks_ca_cert        = module.eks.cluster_certificate_authority_data
  cluster_name       = module.eks.cluster_name
  ecr_repository_url = module.ecr.repository_url
  ecr_name           = module.ecr.ecr_name
  aws_region         = var.aws_region
  depends_on         = [module.eks]
}

module "argo_cd" {
  source              = "./modules/argo_cd"
  eks_host            = module.eks.cluster_endpoint
  eks_ca_cert         = module.eks.cluster_certificate_authority_data
  cluster_name        = module.eks.cluster_name
  aws_region          = var.aws_region
  helm_chart_repo_url = "https://github.com/SerhiiMis/goit-devops-ci-cd.git"
  depends_on          = [module.eks]
}

resource "random_password" "db_master" {
  length           = 16
  special          = true
  override_special = "!#$%&*()_+"
}