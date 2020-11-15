provider "aws" {
  region = "us-east-1"
}

provider "random" {}

resource "aws_key_pair" "default" {
  public_key = var.public_key
}


data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2"
}


resource "aws_instance" "public" {
  subnet_id     = aws_subnet.public_us_east_1a.id
  ami           = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.public_instance.id
  ]

  key_name = aws_key_pair.default.key_name

  tags = {
    Name = "public"
  }
}

resource "aws_instance" "private" {
  subnet_id     = aws_subnet.private_us_east_1a.id
  ami           = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.private_instance.id
  ]

  key_name = aws_key_pair.default.key_name

  tags = {
    Name = "private"
  }
}

resource "aws_vpn_gateway_route_propagation" "public" {
  route_table_id = aws_route_table.public.id
  vpn_gateway_id = aws_vpn_gateway.default.id
}

resource "aws_vpn_gateway_route_propagation" "private" {
  route_table_id = aws_route_table.private.id
  vpn_gateway_id = aws_vpn_gateway.default.id
}

resource "aws_customer_gateway" "default" {
  bgp_asn    = "65000"
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"

  tags = {
    Name = "tf-vpn-sandbox"
  }
}

resource "aws_vpn_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "tf-vpn-sandbox"
  }
}

resource "random_string" "tunnel1_preshared_key" {
  length  = 12
  special = false
}

resource "random_string" "tunnel2_preshared_key" {
  length  = 12
  special = false
}


resource "aws_vpn_connection" "default" {
  vpn_gateway_id      = aws_vpn_gateway.default.id
  type                = aws_customer_gateway.default.type
  customer_gateway_id = aws_customer_gateway.default.id
  static_routes_only  = true

  tunnel1_preshared_key = random_string.tunnel1_preshared_key.result
  tunnel2_preshared_key = random_string.tunnel2_preshared_key.result

  tags = {
    Name = "tf-vpn-sandbox"
  }

}

resource "aws_vpn_connection_route" "default" {
  count = length(var.customer_gateway_route_destination_ip)

  vpn_connection_id      = aws_vpn_connection.default.id
  destination_cidr_block = var.customer_gateway_route_destination_ip[count.index]
}