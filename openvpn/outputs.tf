output "aws_instance_openvpn_public_ip" {
  value = aws_instance.openvpn.public_ip
}

output "aws_instance_private_private_ip" {
  value = aws_instance.private.private_ip
}