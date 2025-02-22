resource "azurerm_resource_group" "rg-ba-kay" {
  location = "West Europe"
  name     = "rg-ba-kay"
}

module "storage" {
  source = "./datalake"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}

module "monitor" {
  source = "./monitor"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}

module "kubernetes" {
  source = "./kubernetes"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
  LOG_ANALYTICS_WORKSPACE_ID = module.monitor.LOG_ANALYTICS_WORKSPACE_ID
}