provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "default" {
  public_key = var.public_key
}

resource "aws_instance" "openvpn" {
  ami           = "ami-037ff6453f0855c46" # OpenVPN - BYOL - (up to 2 clients free)
  instance_type = "t3.medium"

  vpc_security_group_ids = [
    aws_security_group.vpn.id,
  ]

  subnet_id = aws_subnet.public_us_east_1a.id
  key_name  = aws_key_pair.default.key_name

  tags = {
    Name = "openvpn"
  }
}

data "aws_ssm_parameter" "amazon_linux_2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn-ami-hvm-x86_64-gp2"
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