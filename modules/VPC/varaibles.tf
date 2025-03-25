variable "aws_region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}
variable "subnet_details" {
  description = "A map of subnet details with CIDR blocks, public/private status, and availability zones"
  type = map(object({
    cidr   = string
    public = bool
    az     = string
  }))
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

