output "cluster_endpoint" {
  description = "The endpoint for the EKS Control Plane API. Use this to connect kubectl to the cluster."
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate EKS cluster."
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_name" {
  description = "The name of the EKS cluster created."
  value       = module.eks.cluster_name
}

