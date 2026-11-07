# terraform-eks-devsecops

Enterprise-style AWS EKS microservices DevSecOps platform.

## Current implementation

The `feature/enterprise-eks-platform` branch contains the first DEV infrastructure foundation:

- Reusable Terraform VPC module with two public and two private subnets.
- One NAT Gateway for lab cost control (use one per AZ for production resilience).
- Amazon EKS control plane with KMS encryption and CloudWatch control-plane logs.
- EKS-managed VPC CNI, CoreDNS, and kube-proxy add-ons with provider-discovered versions.
- Managed node group using EKS-optimized AL2023 AMI, encrypted gp3 root disk, IMDSv2, and configurable Spot/On-Demand capacity.
- Restricted public Kubernetes API CIDR input; private endpoint access enabled.
- Deployment guide and example variables under `envs/dev`.

## Start here

Read [Phase 1 deployment guide](docs/phase-1-deploy.md) before running Terraform.

**Do not apply until you have set your administrator public IP as a /32 CIDR, confirmed the AWS account and region, reviewed the Terraform plan, and configured an AWS Budget.** The lab creates billable resources including EKS, NAT Gateway, EC2 instances, EBS, KMS, and CloudWatch Logs.

## Project roadmap

- [Architecture](docs/architecture.md)
- [Implementation roadmap](docs/implementation-roadmap.md)

This repository is a learning and portfolio project. A successful Git commit does not mean infrastructure has been deployed or validated in an AWS account.
