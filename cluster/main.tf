resource "azurerm_storage_account" "sa-hdi-kc-ba-kay" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = "sahdikcbakay"
  resource_group_name      = var.resource_group_name
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs-sa-hdi-kc-ba-kay" {
  name = "fssahdikcbakay"
  storage_account_id = azurerm_storage_account.sa-hdi-kc-ba-kay.id
}

resource "azurerm_virtual_network" "vn-hdi-kc-ba-kay" {
  name = "vnhdikcbakay"
  location = var.location
  resource_group_name = var.resource_group_name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sn-hdi-kc-ba-kay" {
  name = "snhdikcbakay"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn-hdi-kc-ba-kay.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_hdinsight_kafka_cluster" "hdi-kc-ba-kay" {
  name = "hdikcbakay"
    resource_group_name = var.resource_group_name
    location = var.location
    cluster_version = "5.1"
    component_version {
        kafka = "3.2.0"
    }
    gateway {
      password = var.GATEWAY_PASSWORD
      username = "kay_admin"
    }
    roles {
      head_node {
        username = "kay_admin"
        vm_size  = "Standard_D4a_V4"
        password = var.VM_PASSWORD
        virtual_network_id = azurerm_virtual_network.vn-hdi-kc-ba-kay.id
        subnet_id = azurerm_subnet.sn-hdi-kc-ba-kay.id
      }
      zookeeper_node {
        username = "kay_admin"
        vm_size  = "Standard_D4a_V4"
        password = var.VM_PASSWORD
        virtual_network_id = azurerm_virtual_network.vn-hdi-kc-ba-kay.id
        subnet_id = azurerm_subnet.sn-hdi-kc-ba-kay.id
      }
      worker_node {
        number_of_disks_per_node = 1
        target_instance_count    = 3
        username                 = "kay_admin"
        password = var.VM_PASSWORD
        vm_size                  = "Standard_D8a_V4"
        virtual_network_id = azurerm_virtual_network.vn-hdi-kc-ba-kay.id
        subnet_id = azurerm_subnet.sn-hdi-kc-ba-kay.id
      }
    }
    storage_account_gen2 {
      filesystem_id                = azurerm_storage_data_lake_gen2_filesystem.fs-sa-hdi-kc-ba-kay.id
      is_default                   = true
      managed_identity_resource_id = azurerm_storage_account.sa-hdi-kc-ba-kay.identity[0].identity_ids[0]
      storage_resource_id          = azurerm_storage_account.sa-hdi-kc-ba-kay.id
    }
    tier = "Standard"
    monitor {
      log_analytics_workspace_id = var.LOG_ANALYTICS_WORKSPACE_ID
      primary_key                = var.LOG_ANALYTICS_WORKSPACE_PRIMARY_KEY
    }
}