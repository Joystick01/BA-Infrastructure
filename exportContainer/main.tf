resource "azurerm_subnet" "sn-ec-ba-kay" {
  address_prefixes = ["10.0.3.0/24"]
  name                 = "snecbakay"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.VIRTUAL_NETWORK_NAME
}

resource "azurerm_container_group" "cg-ec-ba-kay" {
  location            = var.location
  name                = "cgecbakay"
  os_type             = "Linux"
  resource_group_name = var.resource_group_name
  ip_address_type = "Private"
  subnet_ids = [azurerm_subnet.sn-ec-ba-kay.id]

  container {
    name = "exporter"
    image = "ghcr.io/joystick01/kafkaexporter:0.1.3"
    cpu = 2
    memory = 8

    environment_variables = {
      WRITER_TYPE = "DATALAKE"
      DATALAKE_ENDPOINT = var.DATALAKE_ENDPOINT
      DATALAKE_SAS_TOKEN = var.DATALAKE_SAS_TOKEN
      DATALAKE_FILESYSTEM = var.DATALAKE_FILESYSTEM
      DATALAKE_FILE_MESSAGE_COUNT = 161290
      DATALAKE_PADDING = 4
      DATALAKE_PREFIX = var.DATALAKE_PREFIX
      KAFKA_TOPICS = "ingress, egress"
      BOOTSTRAP_SERVERS_CONFIG = var.KAFKA_BOOTSTRAP_SERVERS
      MAX_POLL_RECORDS_CONFIG = 1000
    }

  }
}