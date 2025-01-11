
resource "azurerm_user_assigned_identity" "uai-hdi-kc-ba-kay" {
  location            = var.location
  name                = "uaihdikcbakay"
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "ra-hdi-kc-ba-kay" {
  scope = azurerm_storage_account.sa-hdi-kc-ba-kay.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id = azurerm_user_assigned_identity.uai-hdi-kc-ba-kay.principal_id
}

resource "azurerm_storage_account" "sa-hdi-kc-ba-kay" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = "sahdikcbakay"
  resource_group_name      = var.resource_group_name
  identity {
    type = "SystemAssigned, UserAssigned"
    identity_ids = [
        azurerm_user_assigned_identity.uai-hdi-kc-ba-kay.id
    ]
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

resource "azurerm_network_security_group" "nsg-hdi-kc-ba-kay" {
  location            = var.location
  name                = "nsghdikcbakay"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "inb-nsg-rule-hdi-kc-ba-kay" {
  access                     = "Allow"
  destination_address_prefix = "*"
  destination_port_range      = "*"
  direction                  = "Inbound"
  name                       = "inbnsgrulehdikcbakay"
  network_security_group_name = azurerm_network_security_group.nsg-hdi-kc-ba-kay.name
  priority                   = 110
  protocol                   = "*"
  source_address_prefix      = "*"
  source_port_range          = "*"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_security_rule" "out-nsg-rule-hdi-kc-ba-kay" {
  access                     = "Allow"
  destination_address_prefix = "*"
  destination_port_range      = "*"
  direction                  = "Outbound"
  name                       = "outnsgrulehdikcbakay"
  network_security_group_name = azurerm_network_security_group.nsg-hdi-kc-ba-kay.name
  priority                   = 111
  protocol                   = "*"
  source_address_prefix      = "*"
  source_port_range          = "*"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "sn1-hdi-kc-ba-kay" {
  name = "sn1hdikcbakay"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn-hdi-kc-ba-kay.name
  address_prefixes = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage"]

}

resource "azurerm_subnet_network_security_group_association" "nsg1-association-hdi-kc-ba-kay" {
  subnet_id                 = azurerm_subnet.sn1-hdi-kc-ba-kay.id
  network_security_group_id = azurerm_network_security_group.nsg-hdi-kc-ba-kay.id
}

resource "azurerm_subnet" "sn2-hdi-kc-ba-kay" {
  name = "sn2hdikcbakay"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn-hdi-kc-ba-kay.name
  address_prefixes = ["10.0.2.0/24"]
  service_endpoints = ["Microsoft.Storage"]

}

resource "azurerm_subnet_network_security_group_association" "nsg2-association-hdi-kc-ba-kay" {
  subnet_id                 = azurerm_subnet.sn2-hdi-kc-ba-kay.id
  network_security_group_id = azurerm_network_security_group.nsg-hdi-kc-ba-kay.id
}

resource "azurerm_subnet" "sn3-hdi-kc-ba-kay" {
  name = "sn3hdikcbakay"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vn-hdi-kc-ba-kay.name
  address_prefixes = ["10.0.3.0/24"]
  service_endpoints = ["Microsoft.Storage"]

}

resource "azurerm_subnet_network_security_group_association" "nsg3-association-hdi-kc-ba-kay" {
  subnet_id                 = azurerm_subnet.sn3-hdi-kc-ba-kay.id
  network_security_group_id = azurerm_network_security_group.nsg-hdi-kc-ba-kay.id
}

resource "azurerm_hdinsight_kafka_cluster" "hdi-kc-ba-kay" {
  name = "hdikcbakay"
    resource_group_name = var.resource_group_name
    location = var.location
    cluster_version = "5.1"
    tls_min_version = "1.2"
    component_version {
        kafka = "3.2"
    }
    gateway {
      password = var.GATEWAY_PASSWORD
      username = "kay_admin"
    }
    roles {
      head_node {
        username = "kay_admin"
        vm_size  = "Standard_A4_V2"
        password = var.VM_PASSWORD
        virtual_network_id = azurerm_virtual_network.vn-hdi-kc-ba-kay.id
        subnet_id = azurerm_subnet.sn1-hdi-kc-ba-kay.id
      }
      zookeeper_node {
        username = "kay_admin"
        vm_size  = "Standard_A4_V2"
        password = var.VM_PASSWORD
        virtual_network_id = azurerm_virtual_network.vn-hdi-kc-ba-kay.id
        subnet_id = azurerm_subnet.sn2-hdi-kc-ba-kay.id
      }
      worker_node {
        number_of_disks_per_node = 1
        target_instance_count    = 3
        username                 = "kay_admin"
        password = var.VM_PASSWORD
        vm_size                  = "Standard_A4_V2"
        virtual_network_id = azurerm_virtual_network.vn-hdi-kc-ba-kay.id
        subnet_id = azurerm_subnet.sn3-hdi-kc-ba-kay.id
      }
    }
    storage_account_gen2 {
      filesystem_id                = azurerm_storage_data_lake_gen2_filesystem.fs-sa-hdi-kc-ba-kay.id
      is_default                   = true
      managed_identity_resource_id = azurerm_user_assigned_identity.uai-hdi-kc-ba-kay.id
      storage_resource_id          = azurerm_storage_account.sa-hdi-kc-ba-kay.id
    }
    tier = "Standard"
    monitor {
      log_analytics_workspace_id = var.LOG_ANALYTICS_WORKSPACE_ID
      primary_key                = var.LOG_ANALYTICS_WORKSPACE_PRIMARY_KEY
    }
}

