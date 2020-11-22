output "aws_instance_vpc_10_111_0_0_pfsense_public_ip" {
  value = aws_instance.vpc_10_111_0_0_pfsense.public_ip
}

output "aws_instance_vpc_10_111_0_0_pfsense_private_ip" {
  value = aws_instance.vpc_10_111_0_0_pfsense.private_ip
}

output "aws_instance_vpc_10_222_0_0_pfsense_public_ip" {
  value = aws_instance.vpc_10_222_0_0_pfsense.public_ip
}

output "aws_instance_vpc_10_222_0_0_pfsense_private_ip" {
  value = aws_instance.vpc_10_222_0_0_pfsense.private_ip
}

output "aws_instance_vpc_10_111_0_0_private_private_ip" {
  value = aws_instance.vpc_10_111_0_0_private.private_ip
}

output "aws_instance_vpc_10_222_0_0_private_private_ip" {
  value = aws_instance.vpc_10_222_0_0_private.private_ip
}