variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true # 이 변수가 민감한 정보임을 표시
}

variable "github_organization" {
  description = "GitHub Organization name (e.g., DevOpsLabs_JCG)"
  type        = string
}

variable "app_repo_name" {
  description = "Application repository name (e.g., metric-app)"
  type        = string
  default     = "k8s-metric-app"
}

variable "gitops_config_repo_name" {
  description = "GitOps configuration repository name (e.g., k8s-gitops-configs)"
  type        = string
  default     = "k8s-gitops-configs"
}
