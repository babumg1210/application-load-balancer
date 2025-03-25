# Outputs for us-west-2
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID of the VPC created in us-west-2"
}
output "subnet_details" {
  value = {
    for subnet_key, subnet in aws_subnet.this : subnet_key => {
      id   = subnet.id
      cidr = subnet.cidr_block
      az   = subnet.availability_zone
    }
  }
}