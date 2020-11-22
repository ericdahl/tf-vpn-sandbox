resource "aws_vpc" "vpc_10_111_0_0" {
  cidr_block = "10.111.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf-vpn-sandbox-vpc_10_111_0_0"
  }
}

resource "aws_subnet" "vpc_10_111_0_0_public_us_east_1a" {
  vpc_id = aws_vpc.vpc_10_111_0_0.id

  cidr_block              = "10.111.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "vpc_10_111_0_0_public_us_east_1a"
  }
}

resource "aws_subnet" "vpc_10_111_0_0_private_us_east_1a" {
  vpc_id = aws_vpc.vpc_10_111_0_0.id

  cidr_block        = "10.111.111.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "vpc_10_111_0_0_private_us_east_1a"
  }
}

resource "aws_internet_gateway" "vpc_10_111_0_0" {
  vpc_id = aws_vpc.vpc_10_111_0_0.id
}

resource "aws_route_table" "vpc_10_111_0_0" {
  vpc_id = aws_vpc.vpc_10_111_0_0.id

  tags = {
    Name = "vpc_10_111_0_0_public"
  }
}

resource "aws_route" "vpc_10_111_0_0_public_default" {
  route_table_id         = aws_route_table.vpc_10_111_0_0.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_10_111_0_0.id
}

//resource "aws_route" "vpc_10_111_0_0_public_rfc1918_10_0_0_0_8" {
//  route_table_id         = aws_route_table.vpc_10_111_0_0.id
//  destination_cidr_block = "10.0.0.0/8"
//  network_interface_id = aws_instance.vpc_10_111_0_0_pfsense.primary_network_interface_id
//}


resource "aws_route_table_association" "vpc_10_111_0_0_public_us_east_1a" {
  route_table_id = aws_route_table.vpc_10_111_0_0.id
  subnet_id      = aws_subnet.vpc_10_111_0_0_public_us_east_1a.id
}

resource "aws_route_table" "vpc_10_111_0_0_private" {
  vpc_id = aws_vpc.vpc_10_111_0_0.id

  tags = {
    Name = "vpc_10_111_0_0_private"
  }
}

resource "aws_route" "vpc_10_111_0_0_private_rfc1918_10_0_0_0_8" {
  route_table_id         = aws_route_table.vpc_10_111_0_0_private.id
  destination_cidr_block = "10.0.0.0/8"
  network_interface_id   = aws_instance.vpc_10_111_0_0_pfsense.primary_network_interface_id
}

resource "aws_route_table_association" "vpc_10_111_0_0_private_us_east_1a" {
  route_table_id = aws_route_table.vpc_10_111_0_0_private.id
  subnet_id      = aws_subnet.vpc_10_111_0_0_private_us_east_1a.id
}
