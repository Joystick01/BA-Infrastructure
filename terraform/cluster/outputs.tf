output "VM_PASSWORD" {
  value = var.VM_PASSWORD
}

output "GATEWAY_PASSWORD" {
  value = var.GATEWAY_PASSWORD
}


output "VIRTUAL_NETWORK_NAME" {
  value = azurerm_virtual_network.vn-hdi-kc-ba-kay.name
}

output "NETWORK_SECURITY_GROUP_ID" {
  value = azurerm_network_security_group.nsg-hdi-kc-ba-kay.id
}