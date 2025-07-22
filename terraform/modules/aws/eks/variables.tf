variable "cluster_name" {
  description = "클러스터의 이름"
  type        = string
}

variable "vpc_id" {
  description = "클러스터가 위치할 VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "클러스터 워커 노드가 위치할 Subnet ID 목록"
  type        = list(string)
}
