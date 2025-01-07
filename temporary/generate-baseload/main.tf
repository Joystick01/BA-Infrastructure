resource "azurerm_container_group" "cg-ba-kay-tmp-baseload" {
  name                         = "cgbakaytmpbaseload"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  os_type                      = "Linux"

  container {
    cpu    = 2
    image  = "ghcr.io/joystick01/coolersimulator:0.1.1"
    memory = 4
    name   = "coolersimulator"
    environment_variables = {
      "PAYLOAD_WRITER_TYPE" = "DATALAKE"
      "DATALAKE_PAYLOAD_WRITER_ENDPOINT" = var.DATALAKE_PAYLOAD_WRITER_ENDPOINT
      "DATALAKE_PAYLOAD_WRITER_SAS_TOKEN" = var.DATALAKE_PAYLOAD_WRITER_SAS_TOKEN
      "DATALAKE_PAYLOAD_WRITER_FILESYSTEM" = var.DATALAKE_PAYLOAD_WRITER_FILESYSTEM
      "DATALAKE_PAYLOAD_WRITER_FILE_MESSAGE_COUNT" = "322580"
      "DATALAKE_PAYLOAD_WRITER_FILE_COUNT" = "157"
    }
    ports {
      port = 80
      protocol = "TCP"
    }
  }

  restart_policy = "Never"

}