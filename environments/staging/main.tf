terraform {
  required_version = ">= 1.5.0"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
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
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

locals {
  tags = {
    Environment = var.environment
    Project     = "eks-devsecops"
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source             = "../../modules/vpc"
  cluster_name       = var.cluster_name
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  enable_nat_gateway = var.enable_nat_gateway
  tags               = local.tags
}

module "security" {
  source             = "../../modules/security"
  enable_guardduty   = var.enable_guardduty
  enable_securityhub = var.enable_securityhub
}

module "eks" {
  source                    = "../../modules/eks"
  cluster_name              = var.cluster_name
  cluster_version           = var.cluster_version
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  endpoint_private_access   = var.endpoint_private_access
  endpoint_public_access    = var.endpoint_public_access
  public_access_cidrs       = var.public_access_cidrs
  enabled_cluster_log_types = var.enabled_cluster_log_types
  log_retention_days        = var.log_retention_days
  addon_vpc_cni_version     = var.addon_vpc_cni_version
  addon_coredns_version     = var.addon_coredns_version
  addon_kube_proxy_version  = var.addon_kube_proxy_version
  addon_ebs_csi_version     = var.addon_ebs_csi_version
  tags                      = local.tags
}

module "node_groups" {
  source             = "../../modules/node_groups"
  cluster_name       = module.eks.cluster_name
  cluster_version    = var.cluster_version
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_types     = var.instance_types
  desired_size       = var.desired_size
  min_size           = var.min_size
  max_size           = var.max_size
  capacity_type      = var.capacity_type
  disk_size          = var.disk_size
  tags               = local.tags
}

module "irsa_albc" {
  source            = "../../modules/irsa"
  cluster_name      = module.eks.cluster_name
  name              = "aws-load-balancer-controller"
  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn
  service_account   = "kube-system:aws-load-balancer-controller"
  policy_json       = file("${path.module}/policies/aws-load-balancer-controller.json")
  tags              = local.tags
}

module "irsa_external_dns" {
  source            = "../../modules/irsa"
  cluster_name      = module.eks.cluster_name
  name              = "external-dns"
  oidc_provider     = module.eks.oidc_provider
  oidc_provider_arn = module.eks.oidc_provider_arn
  service_account   = "external-dns:external-dns"
  policy_json       = file("${path.module}/policies/external-dns.json")
  tags              = local.tags
}

module "addons" {
  source                                = "../../modules/addons"
  cluster_name                          = module.eks.cluster_name
  vpc_id                                = module.vpc.vpc_id
  enable_aws_load_balancer_controller   = true
  aws_load_balancer_controller_role_arn = module.irsa_albc.role_arn
  enable_external_dns                   = true
  external_dns_role_arn                 = module.irsa_external_dns.role_arn
  enable_cert_manager                   = var.enable_cert_manager
  enable_metrics_server                 = var.enable_metrics_server
}

