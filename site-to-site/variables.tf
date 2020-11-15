variable "admin_cidrs" {
  type    = list
  default = []
}

variable "public_key" {
}

variable "customer_gateway_ip" {}

variable "customer_gateway_route_destination_ip" {
  type    = list
  default = []
}