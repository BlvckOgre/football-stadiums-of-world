# variables.tf
# Declare input variables

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "data_factory_name" {
  description = "Name of the Data Factory instance"
  type        = string
}