resource "azurerm_log_analytics_workspace" "law-ba-kay" {
  location            = var.location
  name                = "lawbakay"
  resource_group_name = var.resource_group_name
  retention_in_days = 30
}