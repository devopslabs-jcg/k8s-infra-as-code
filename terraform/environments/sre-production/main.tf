terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC 모듈 호출
module "vpc" {
  source = "../../modules/aws/vpc"

  cluster_name       = var.cluster_name
  vpc_cidr           = var.vpc_cidr
  aws_region         = var.aws_region
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
}

# EKS 모듈 호출
module "eks" {
  source = "../../modules/aws/eks"

  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
# 보안을 위해 워커 노드를 Private Subnet에 두고 NAT 게이트웨이를 사용하는 것이 표준
  subnet_ids   = module.vpc.public_subnets
}

# Kubernetes Provider 설정
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint # EKS 모듈의 cluster_endpoint 출력
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data) # EKS 모듈의 CA 데이터 출력
  token                  = data.aws_eks_cluster_auth.main.token # EKS 클러스터 인증 토큰
}

# EKS 클러스터 인증 토큰을 가져오기 위한 data source
data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name # EKS 모듈의 cluster_name 출력
}

