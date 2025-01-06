output "STORAGE_ACCOUNT_URL" {
  value = azurerm_storage_account.sa-ba-kay-persistent.primary_dfs_endpoint
}

output "STORAGE_ACCOUNT_KEY" {
  value = data.azurerm_storage_account_sas.sas-sa-ba-kay-persistent.sas
  sensitive = true
}

output "STORAGE_FILESYSTEM_NAME" {
  value = azurerm_storage_data_lake_gen2_filesystem.fs-sa-ba-kay-persistent.name
}