# outputs.tf

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "vm_public_ip" {
  description = "가상 머신의 공인 IP 주소"
  value       = azurerm_public_ip.main.ip_address
}

output "storage_account_id" {
  description = "생성된 스토리지 계정의 ID"
  value       = azurerm_storage_account.main.id
}

output "key_vault_uri" {
  description = "생성된 키 볼트의 URI"
  value       = azurerm_key_vault.main.vault_uri
}
