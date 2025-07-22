variable "aws_region" {
  description = "EKS 클러스터를 생성할 AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "cluster_name" {
  description = "EKS 클러스터의 이름"
  type        = string
  default     = "sre-portfolio-cluster"
}

# VPC의 전체 IP 대역을 '10.0.0.0/16'으로 설정
variable "vpc_cidr" {
  description = "클러스터가 사용할 VPC의 CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

# 아래 서브넷들은 모두 '10.0.x.x' 대역으로, 위 VPC 대역에 포함
variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# ------------------------------------

variable "availability_zones" {
  type    = list(string)
  default = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
}
