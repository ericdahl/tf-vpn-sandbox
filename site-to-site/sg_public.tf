resource "aws_security_group" "public_instance" {
  vpc_id = aws_vpc.default.id
  name   = "public-instance"
}

resource "aws_security_group_rule" "public_instance_egress_all" {
  security_group_id = aws_security_group.public_instance.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_instance_ingress_22" {
  security_group_id = aws_security_group.public_instance.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.admin_cidrs
}

resource "aws_security_group_rule" "public_instance_ingress_icmp" {
  security_group_id = aws_security_group.public_instance.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1 # ping
  to_port           = -1

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "public_instance_ingress_all" {
  security_group_id = aws_security_group.public_instance.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}