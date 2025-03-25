output "private_security_group_ids" {
  value = { for k, sg in aws_security_group.private_sg : k => sg.id }
  description = "A map of security group IDs for each private subnet"
}