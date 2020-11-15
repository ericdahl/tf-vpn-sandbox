output "aws_instance_private_private_ip" {
  value = aws_instance.private.private_ip
}

output "aws_instance_public_public_ip" {
  value = aws_instance.public.public_ip
}

output "aws_vpn_connection_default_tunnel1_address" {
  value = aws_vpn_connection.default.tunnel1_address
}

output "aws_vpn_connection_default_tunnel2_address" {
  value = aws_vpn_connection.default.tunnel2_address
}