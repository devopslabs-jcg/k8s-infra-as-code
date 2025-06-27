output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "The ID of the created virtual network."
  value       = azurerm_virtual_network.main.id
}

output "aks_subnet_id" {
  description = "The ID of the subnet for AKS."
  value       = azurerm_subnet.aks.id
}

