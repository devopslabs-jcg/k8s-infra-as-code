# variables.tf

variable "resource_group_name" {
  description = "생성할 리소스 그룹의 이름"
  type        = string
  default     = "terraform-base-infra-rg"
}

variable "location" {
  description = "리소스를 배포할 Azure 지역"
  type        = string
  default     = "Korea Central"
}

variable "vnet_name" {
  description = "가상 네트워크의 이름"
  type        = string
  default     = "main-vnet"
}

variable "storage_account_name" {
  description = "스토리지 계정의 이름 (전역적으로 고유해야 함)"
  type        = string
}

variable "vm_admin_username" {
  description = "VM에 접속할 관리자 사용자 이름"
  type        = string
  default     = "azureuser"
}

variable "vm_admin_ssh_public_key" {
  description = "VM 접속을 위한 SSH 공개 키"
  type        = string
  sensitive   = true # 터미널에 키 값이 출력되지 않도록 설정
}
