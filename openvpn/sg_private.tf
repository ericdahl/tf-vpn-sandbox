resource "aws_security_group" "private_instance" {
  vpc_id = aws_vpc.default.id
  name   = "private-instance"
}

resource "aws_security_group_rule" "private_instance_egress_all" {
  security_group_id = aws_security_group.private_instance.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_instance_ingress_22" {
  security_group_id = aws_security_group.private_instance.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [aws_vpc.default.cidr_block]
}

resource "aws_security_group_rule" "private_instance_ingress_icmp" {
  security_group_id = aws_security_group.private_instance.id
  type              = "ingress"
  protocol          = "icmp"
  from_port         = -1 # ping
  to_port           = -1

  cidr_blocks = [aws_vpc.default.cidr_block]
}