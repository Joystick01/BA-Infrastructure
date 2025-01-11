resource "azurerm_storage_account" "sa-ba-kay-datalake" {
  name = "sabakaydatalake"
  resource_group_name = var.resource_group_name
    location = var.location
    account_tier = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs-sa-ba-kay-datalake" {
  name               = "fssabakaydatalake"
  storage_account_id = azurerm_storage_account.sa-ba-kay-datalake.id
}

data "azurerm_storage_account_sas" "sas-sa-ba-kay-persistent" {
    connection_string = azurerm_storage_account.sa-ba-kay-datalake.primary_connection_string
    resource_types {
        service   = true
        container = true
        object    = true
    }
    services {
        blob  = true
        file  = true
        queue = true
        table = true
    }
    start  = "2025-01-01"
    expiry = "2025-02-01"
  permissions {
    read = true
    write = true
    delete = true
    list = true
    add = true
    create = true
    update = true
    process = true
    tag = true
    filter = true
  }

}