resource "azurerm_resource_group" "rg-ba-kay" {
  location = "West Europe"
  name     = "rg-ba-kay"
}

module "storage" {
  source = "datalake"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}

module "monitor" {
  source = "monitor"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}

module "cluster" {
  source = "cluster"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
  VM_PASSWORD = var.VM_PASSWORD
  GATEWAY_PASSWORD = var.GATEWAY_PASSWORD
  LOG_ANALYTICS_WORKSPACE_ID = module.monitor.LOG_ANALYTICS_WORKSPACE_ID
  LOG_ANALYTICS_WORKSPACE_PRIMARY_KEY = module.monitor.LOG_ANALYTICS_WORKSPACE_PRIMARY_KEY
}

/*
module "processingContainers" {
  source = "./processingContainers"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
  VIRTUAL_NETWORK_NAME = module.cluster.VIRTUAL_NETWORK_NAME
  KAFKA_BOOTSTRAP_SERVERS = var.KAFKA_BOOTSTRAP_SERVERS
  KAFKA_SEND_RATE = 52
  NETWORK_SECURITY_GROUP_ID = module.cluster.NETWORK_SECURITY_GROUP_ID
}
 */