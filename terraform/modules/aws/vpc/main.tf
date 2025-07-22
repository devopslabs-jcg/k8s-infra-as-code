module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name = var.cluster_name
  cidr = var.vpc_cidr

  # 가용 영역과 서브넷 설정을 environments 에서 전달받음
  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # EKS 클러스터에 필요한 기본 설정을 자동으로 활성화
  enable_nat_gateway   = false
  single_nat_gateway   = false # NAT 게이트웨이 비활성화로 비용 절약
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }
}
