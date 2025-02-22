output "LOG_ANALYTICS_WORKSPACE_ID" {
  value = azurerm_log_analytics_workspace.law-ba-kay.id
}

output "LOG_ANALYTICS_WORKSPACE_PRIMARY_KEY" {
  value = azurerm_log_analytics_workspace.law-ba-kay.primary_shared_key
  sensitive = true
}