provider "github" {
  token = var.github_token
  owner = var.github_organization
}

// 1. 스테이징 환경 애플리케이션 코드 리포지토리 생성
resource "github_repository" "app_repo_stg" {
  name        = "${var.app_repo_name}-stg"
  description = "Application code for the Metric Monitoring System (Staging)."
  visibility  = "public"
}

// 2. 스테이징 환경 GitOps 설정 리포지토리 생성
resource "github_repository" "gitops_config_repo_stg" {
  name        = "${var.gitops_config_repo_name}-stg"
  description = "Kubernetes manifests and GitOps configurations for the project (Staging)."
  visibility  = "public"
}

// 3. 스테이징 리포지토리에 GitHub Actions 시크릿 설정
resource "github_actions_secret" "ghcr_username_stg" {
  repository      = github_repository.app_repo_stg.name
  secret_name     = "GHCR_USERNAME"
  plaintext_value = "jangk34"
}

resource "github_actions_secret" "ghcr_token_stg" {
  repository      = github_repository.app_repo_stg.name
  secret_name     = "GHCR_TOKEN"
  plaintext_value = var.github_token
}

// 생성된 스테이징 리포지토리의 URL 출력
output "app_repo_stg_url" {
  value       = github_repository.app_repo_stg.html_url
  description = "URL of the staging application repository"
}

output "gitops_config_repo_stg_url" {
  value       = github_repository.gitops_config_repo_stg.html_url
  description = "URL of the staging GitOps configuration repository"
}
