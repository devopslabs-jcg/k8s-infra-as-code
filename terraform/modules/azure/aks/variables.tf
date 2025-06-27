variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where AKS will be created."
  type        = string
}

variable "location" {
  description = "The Azure region for the AKS cluster."
  type        = string
}

variable "vnet_subnet_id" {
  description = "The ID of the subnet to which the AKS nodes will be connected."
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes for the AKS cluster."
  type        = number
  default     = 2
}

variable "environment" {
  description = "The deployment environment name (e.g., dev, prod)."
  type        = string
  default     = "development"
}

