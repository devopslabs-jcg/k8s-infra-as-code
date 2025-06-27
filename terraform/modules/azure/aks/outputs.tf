output "cluster_name" {
  description = "The name of the created AKS cluster."
  value       = azurerm_kubernetes_cluster.main.name
}

output "kube_config" {
  description = "The Kubernetes configuration for the cluster."
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}
