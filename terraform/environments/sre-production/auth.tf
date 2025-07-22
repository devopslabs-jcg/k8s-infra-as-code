# Kubernetes Provider 설정
# EKS 클러스터가 생성된 후 kubectl이 작동할 수 있도록 명시적으로 의존성을 설정
resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    # mapRoles는 EKS 모듈이 생성하므로, 여기서는 mapUsers만 추가
    # 만약 워커 노드 역할이 제대로 추가되지 않았다면, mapRoles도 여기에 추가
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::766496852787:user/terraform-admin" # 당신의 IAM 사용자 ARN
        username = "terraform-admin"
        groups   = ["system:masters"] # 클러스터 관리자 권한
      },
    ])
  }
  # 이 ConfigMap이 EKS 클러스터가 완전히 생성된 후에 적용되도록 명시적 의존성 설정
  depends_on = [
    module.eks # 'module.eks'는 environments/sre-production/main.tf에서 호출된 전체 EKS 모듈을 참조
  ]
}

# IMPORTANT: kubernetes provider는 EKS 클러스터 생성이 완료된 후 구성되어야 함
# 일반적으로 kubernetes provider는 kubeconfig를 참조하여 EKS 클러스터에 연결
# 이 예시에서는 EKS 모듈의 output으로 kubeconfig를 생성하고,
# kubernetes provider가 이를 사용하는 방식으로 설정
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }
# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name
# }
