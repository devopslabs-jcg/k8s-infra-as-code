# ~/devops_project/k8s-infra-as-code/terraform/environments/portfolio/outputs.tf

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}

output "cluster_endpoint" {
  description = "EKS 클러스터의 API 서버 엔드포인트"
  value       = module.eks.cluster_endpoint
}
