resource "azurerm_resource_group" "rg-ba-kay" {
  location = "West Europe"
  name     = "rg-ba-kay"
}

module "storage" {
  source = "./persistent"
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}

/*
module "generate-baseload" {
  source = "./temporary/generate-baseload"
  DATALAKE_PAYLOAD_WRITER_ENDPOINT = module.storage.STORAGE_ACCOUNT_URL
  DATALAKE_PAYLOAD_WRITER_SAS_TOKEN = module.storage.STORAGE_ACCOUNT_KEY
  DATALAKE_PAYLOAD_WRITER_FILESYSTEM = module.storage.STORAGE_FILESYSTEM_NAME
  resource_group_name = azurerm_resource_group.rg-ba-kay.name
  location = azurerm_resource_group.rg-ba-kay.location
}
*/