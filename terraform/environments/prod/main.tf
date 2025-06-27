// main.tf
provider "github" {
  token        = var.github_token
  owner = var.github_organization
}

// 1. 애플리케이션 코드 리포지토리 생성 (metric-app)
resource "github_repository" "app_repo" {
  name        = var.app_repo_name
  description = "Application code for the Metric Monitoring System."
  visibility  = "public" # 'public' 또는 'private'으로 설정할 수 있습니다.
}

// 2. GitOps 설정 리포지토리 생성 (k8s-gitops-configs)
resource "github_repository" "gitops_config_repo" {
  name        = var.gitops_config_repo_name
  description = "Kubernetes manifests and GitOps configurations for the project."
  visibility  = "public" # 'public' 또는 'private'으로 설정할 수 있습니다.
}

// 3. GitHub Actions 시크릿 설정 (GHCR 인증 정보)
// 이 시크릿들은 'metric-app' 리포지토리에서 Docker 이미지를 GHCR에 푸시할 때 사용됩니다.
resource "github_actions_secret" "ghcr_username" {
  repository      = github_repository.app_repo.name # <-- repository_id 대신 repository 사용 및 이름 지정
  secret_name     = "GHCR_USERNAME"
  plaintext_value = "jangk34"
}

resource "github_actions_secret" "ghcr_token" {
  repository      = github_repository.app_repo.name # <-- repository_id 대신 repository 사용 및 이름 지정
  secret_name     = "GHCR_TOKEN"
  plaintext_value = var.github_token
}

// 생성된 리포지토리의 URL을 출력하여 확인합니다.
output "app_repo_url" {
  value       = github_repository.app_repo.html_url
  description = "URL of the application repository"
}

output "gitops_config_repo_url" {
  value       = github_repository.gitops_config_repo.html_url
  description = "URL of the GitOps configuration repository"
}
