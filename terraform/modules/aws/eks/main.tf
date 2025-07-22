module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.2"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # EKS 클러스터와 노드에 필요한 IAM 역할 자동 생성
  create_iam_role = true

  eks_managed_node_groups = {
    sre_portfolio_group = {
      min_size     = 1
      max_size     = 2
      desired_size = 1
      instance_types = ["t3.micro"]
    # instance_types = ["t3.medium"] # 스팟으로는 좀 더 큰 인스턴스를 저렴하게 사용
    # capacity_type  = "SPOT" # 스팟 인스턴스 사용
    }
  }
}
