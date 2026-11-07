# Phase 1 — Deploy the DEV EKS foundation

## Prerequisites

- AWS CLI v2 authenticated to the intended account.
- Terraform >= 1.10.
- kubectl compatible with the EKS Kubernetes minor version.
- An administrator public IPv4 address.
- AWS permissions to create VPC, EC2, EKS, IAM, KMS, CloudWatch Logs, and SSM resources.

## 1. Check identity and regional EKS version support

```bash
aws sts get-caller-identity
aws eks describe-addon-versions --kubernetes-version 1.35 --region us-east-1 --query 'addons[].addonName' --output table
aws ec2 describe-instance-type-offerings --region us-east-1 --location-type availability-zone --filters Name=instance-type,Values=c7i-flex.large --query 'InstanceTypeOfferings[].Location' --output table
```

If EKS 1.35 or the requested instance type is not available in the selected region/AZs, choose a currently supported EKS version and an available instance type before planning.

## 2. Configure inputs

```bash
cd envs/dev
cp terraform.tfvars.example terraform.tfvars
```

Find your public IPv4 address from a trusted IP-check service, then edit terraform.tfvars and set:
`admin_public_access_cidr = "YOUR_PUBLIC_IPV4/32"`

Do not use 0.0.0.0/0. Do not commit terraform.tfvars.

## 3. Format, initialize, validate, and plan

```bash
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=tfplan
```

Review the plan carefully. Expected resources include VPC/subnets, one NAT Gateway, EKS control plane, KMS key, CloudWatch log group, add-ons, IAM roles, and a two-node managed node group.

## 4. Apply only after review

```bash
terraform apply tfplan
```

The EKS cluster and managed node group may take several minutes to become active.

## 5. Connect and verify

```bash
aws eks update-kubeconfig --region us-east-1 --name devsecops-dev
kubectl get nodes -o wide
kubectl get pods -A
aws eks describe-cluster --name devsecops-dev --region us-east-1 --query 'cluster.status'
aws eks list-addons --cluster-name devsecops-dev --region us-east-1
```

Expected: cluster status ACTIVE and two worker nodes Ready.

## 6. Remote state

For a team or long-lived environment, create an encrypted, versioned S3 state bucket with public access blocked and restricted IAM access. Configure the backend using:
```bash
cp backend.hcl.example backend.hcl
# Edit backend.hcl with your real bucket name
# Add an S3 backend block to backend.tf:
# terraform { backend "s3" {} }
terraform init -backend-config=backend.hcl -migrate-state
```
Do this before collaborating on the environment. Keep the bucket and state outside the resources managed by this environment.

## 7. Cost and teardown

NAT Gateway, EKS control plane, EC2 worker nodes, EBS volumes, public IPv4 addresses, KMS keys, and CloudWatch logs can incur charges. Set an AWS Budget before applying.

When finished, remove Kubernetes LoadBalancers and other dependent resources first, then run:
```bash
terraform destroy
```
Review the destroy plan before confirming. Retain the state bucket if it is used by other environments.
