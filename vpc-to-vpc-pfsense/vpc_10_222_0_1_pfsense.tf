resource "aws_instance" "vpc_10_222_0_0_pfsense" {
  subnet_id     = aws_subnet.vpc_10_222_0_0_public_us_east_1a.id
  ami           = data.aws_ami.pfsense.id
  instance_type = "m4.large"

  vpc_security_group_ids = [
    aws_security_group.vpc_10_222_0_0_pfsense.id
  ]

  key_name = aws_key_pair.default.key_name

  tags = {
    Name = "vpc_10_222_0_0_pfsense"
  }

  source_dest_check = false
}

resource "aws_security_group" "vpc_10_222_0_0_pfsense" {
  name   = "vpc_10_222_0_0_pfsense"
  vpc_id = aws_vpc.vpc_10_222_0_0.id
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_icmp" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1
  to_port           = -1

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_egress_all" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_other_vpn_remote" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${aws_instance.vpc_10_111_0_0_pfsense.public_ip}/32"]
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_all" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_22" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.admin_cidrs
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_443" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.admin_cidrs
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_500" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  from_port         = 500
  to_port           = 500
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"] # todo: correct IPs
}

resource "aws_security_group_rule" "vpc_10_222_0_0_pfsense_ingress_4500" {
  security_group_id = aws_security_group.vpc_10_222_0_0_pfsense.id
  type              = "ingress"
  from_port         = 4500
  to_port           = 4500
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
}