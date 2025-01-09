resource "azurerm_resource_group" "rg-ba-kay" {
  location = "West Europe"
  name     = "rg-ba-kay"
}

module "storage" {
  source = "./datalake"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}