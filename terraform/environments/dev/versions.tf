// versions.tf
terraform {
  required_version = ">= 1.0.0" # Terraform 최소 요구 버전
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0" # GitHub 프로바이더 버전 (안정적인 최신 버전을 명시)
    }
  }
}
