output "vpc_id" {
  value = aws_vpc.main.id
}
output "private_subnet_ids" {
  value = [for subnet in aws_subnet.this : subnet.id if !subnet.map_public_ip_on_launch]
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.this : subnet.id]
}