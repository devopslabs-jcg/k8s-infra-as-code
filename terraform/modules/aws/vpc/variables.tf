variable "cluster_name" {
  description = "클러스터의 이름"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC의 IP 대역"
  type        = string
}

# environments 에서 전달받을 변수들을 추가
variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "availability_zones" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnet 목록"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnet 목록"
  type        = list(string)
}
