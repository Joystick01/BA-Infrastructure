variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "VIRTUAL_NETWORK_NAME" {
  type = string
}

variable "KAFKA_BOOTSTRAP_SERVERS" {
  type = string
}

variable "KAFKA_SEND_RATE" {
    type = number
}

variable "NETWORK_SECURITY_GROUP_ID" {
    type = string
}