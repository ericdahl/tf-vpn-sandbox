resource "aws_instance" "vpc_10_111_0_0_private" {
  subnet_id     = aws_subnet.vpc_10_111_0_0_private_us_east_1a.id
  ami           = data.aws_ssm_parameter.amazon_linux_2.value
  instance_type = "t3.small"

  vpc_security_group_ids = [
    aws_security_group.vpc_10_111_0_0_private.id
  ]

  key_name = aws_key_pair.default.key_name

  tags = {
    Name = "vpc_10_111_0_0_private"
  }
}

resource "aws_security_group" "vpc_10_111_0_0_private" {
  name   = "vpc_10_111_0_0_private"
  vpc_id = aws_vpc.vpc_10_111_0_0.id
}

resource "aws_security_group_rule" "vpc_10_111_0_0_private_egress_all" {
  security_group_id = aws_security_group.vpc_10_111_0_0_private.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "vpc_10_111_0_0_private_ingress_all" {
  security_group_id = aws_security_group.vpc_10_111_0_0_private.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
