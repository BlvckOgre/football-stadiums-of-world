# outputs.tf
# Output resource information

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_id" {
  value = azurerm_storage_account.datalake.id
}

output "data_factory_id" {
  value = azurerm_data_factory.adf.id
}