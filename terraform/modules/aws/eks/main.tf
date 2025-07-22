module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.2" # 현재 사용 중인 모듈 버전

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  create_iam_role = true

  eks_managed_node_groups = {
    sre_portfolio_group = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.micro"]
    }
  }
}
