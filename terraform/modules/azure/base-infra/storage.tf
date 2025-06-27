# storage.tf

# 스토리지 계정 생성
resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Local-redundant storage

  tags = {
    environment = "Terraform-Demo"
  }
}
