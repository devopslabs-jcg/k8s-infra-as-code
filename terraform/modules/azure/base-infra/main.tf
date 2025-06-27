# main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 모든 리소스가 속할 리소스 그룹 생성
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}
