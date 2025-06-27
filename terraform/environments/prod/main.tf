provider "github" {
  token = var.github_token
  owner = var.github_organization
}

// 1. 운영 환경 애플리케이션 코드 리포지토리 생성
resource "github_repository" "app_repo_prod" {
  name        = "${var.app_repo_name}-prod"
  description = "Application code for the Metric Monitoring System (Production)."
  visibility  = "private" # 운영 환경은 private으로 설정
}

// 2. 운영 환경 GitOps 설정 리포지토리 생성
resource "github_repository" "gitops_config_repo_prod" {
  name        = "${var.gitops_config_repo_name}-prod"
  description = "Kubernetes manifests and GitOps configurations for the project (Production)."
  visibility  = "private" # 운영 환경은 private으로 설정
}

// 3. 운영 리포지토리에 GitHub Actions 시크릿 설정
resource "github_actions_secret" "ghcr_username_prod" {
  repository      = github_repository.app_repo_prod.name
  secret_name     = "GHCR_USERNAME"
  plaintext_value = "jangk34"
}

resource "github_actions_secret" "ghcr_token_prod" {
  repository      = github_repository.app_repo_prod.name
  secret_name     = "GHCR_TOKEN"
  plaintext_value = var.github_token
}

// 생성된 운영 리포지토리의 URL 출력
output "app_repo_prod_url" {
  value       = github_repository.app_repo_prod.html_url
  description = "URL of the production application repository"
}

output "gitops_config_repo_prod_url" {
  value       = github_repository.gitops_config_repo_prod.html_url
  description = "URL of the production GitOps configuration repository"
}
