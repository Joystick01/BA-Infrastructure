resource "azurerm_subnet" "sn-pc-ba-kay" {
  address_prefixes = ["10.0.2.0/24"]
  name                 = "snpcbakay"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.VIRTUAL_NETWORK_NAME
}

resource "azurerm_container_group" "cg-sm-pc-ba-kay" {
  location            = var.location
  name                = "cgsmpcbakay"
  os_type             = "Linux"
  resource_group_name = var.resource_group_name
  ip_address_type = "Private"
  subnet_ids = [azurerm_subnet.sn-pc-ba-kay.id]

  container {
    name = "simulator"
    image = "ghcr.io/joystick01/coolersimulator:0.1.3"
    cpu = 2
    memory = 8

    environment_variables = {
      ERROR_RATE = 1000
      DUPLICATE_RATE = 1000
      PAYLOAD_WRITER_TYPE = "KAFKA"
      PAYLOAD_WRITER_OFFSET = 0
      KAFKA_PAYLOAD_WRITER_TOPIC = "ingress"
      KAFKA_PAYLOAD_WRITER_BOOTSTRAP_SERVERS = var.KAFKA_BOOTSTRAP_SERVERS
      KAFKA_PAYLOAD_WRITER_FLOOD_MESSAGES = var.KAFKA_SEND_RATE * 60 * 60 * 24 * 7
      KAFKA_PAYLOAD_WRITER_SEND_RATE = var.KAFKA_SEND_RATE
    }

  }
}

resource "azurerm_container_group" "cg-pc-pc-ba-kay" {
  location            = var.location
  name                = "cgsmpcbakay"
  os_type             = "Linux"
  resource_group_name = var.resource_group_name
  ip_address_type = "Private"
  subnet_ids = [azurerm_subnet.sn-pc-ba-kay.id]

  container {
    name = "processor"
    image = "ghcr.io/joystick01/messageprocessingservice:0.1.0"
    cpu = 4
    memory = 16

    environment_variables = {
      APPLICATION_ID_CONFIG = "MessageProcessingService"
      BOOTSTRAP_SERVERS_CONFIG = var.KAFKA_BOOTSTRAP_SERVERS
      INPUT_TOPIC = "ingress"
      OUTPUT_TOPIC = "egress"
    }

  }

}