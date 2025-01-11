resource "azurerm_kubernetes_cluster" "aks-ba-kay" {
  name                = "aksbakay"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aksbakay"
  node_os_channel_upgrade = "None"
  identity {
    type = "SystemAssigned"
  }
  default_node_pool {
    name            = "default"
    vm_size = "Standard_D4as_v5"
    os_disk_type = "Ephemeral"
    os_disk_size_gb = 50
    node_count = 1
    enable_auto_scaling = false
    node_labels = {
        "nodepool" = "default"
    }
  }
  oms_agent {
    log_analytics_workspace_id = var.LOG_ANALYTICS_WORKSPACE_ID
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "perf-ba-kay" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks-ba-kay.id
  name                  = "performancenodepool"
  vm_size               = "Standard_D8ads_v5"
  node_count = 4
  enable_auto_scaling = false
  kubelet_disk_type = "temporary"
  node_labels = {
        "nodepool" = "performancenodepool"
  }
  os_disk_type = "Ephemeral"
  os_disk_size_gb = 50
  priority = "Spot"
  spot_max_price = -1
}