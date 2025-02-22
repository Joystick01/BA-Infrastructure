resource "azurerm_kubernetes_cluster" "aks-ba-kay" {
  name                = "aksbakay"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aksbakay"
  identity {
    type = "SystemAssigned"
  }
  default_node_pool {
    name            = "default"
    vm_size = "Standard_D4as_v5"
    #vm_size = "Standard_D2as_v5"
    os_disk_size_gb = 50
    node_count = 1
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
  name                  = "perf"
  vm_size               = "Standard_D8ads_v5"
  #vm_size = "Standard_D2as_v5"
  node_count = 4
  #node_count = 1
  kubelet_disk_type = "Temporary"
  node_labels = {
        "nodepool" = "performancenodepool"
  }
  os_disk_size_gb = 50
}