locals {
  common_tags = {
    Project     = "terraform-eks-devsecops"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  cluster_name       = var.cluster_name
  vpc_cidr           = var.vpc_cidr
  az_count           = var.az_count
  subnet_bits        = 8
  enable_nat_gateway = var.enable_nat_gateway
  tags               = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name                = var.cluster_name
  cluster_version             = var.cluster_version
  vpc_id                      = module.vpc.vpc_id
  private_subnet_ids          = module.vpc.private_subnet_ids
  endpoint_private_access     = true
  endpoint_public_access      = true
  public_access_cidrs         = [var.admin_public_access_cidr]
  enabled_cluster_log_types   = ["api", "audit", "authenticator"]
  log_retention_days          = 7
  addon_vpc_cni_version       = data.aws_eks_addon_version.vpc_cni.version
  addon_coredns_version       = data.aws_eks_addon_version.coredns.version
  addon_kube_proxy_version    = data.aws_eks_addon_version.kube_proxy.version
  tags                        = local.common_tags
}

module "node_groups" {
  source = "../../modules/node_groups"

  cluster_name             = module.eks.cluster_name
  private_subnet_ids       = module.vpc.private_subnet_ids
  node_security_group_ids  = [module.eks.node_security_group_id]
  instance_types           = var.node_instance_types
  disk_size                = 35
  min_size                 = var.node_min_size
  desired_size             = var.node_desired_size
  max_size                 = var.node_max_size
  capacity_type            = var.node_capacity_type
  node_labels              = { environment = "dev", workload = "general" }
  tags                     = local.common_tags
}
