variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

variable "subnet_details" {
  description = "Details of the subnets"
  type = map(object({
    cidr   = string
    public = bool
    az     = string
  }))
}
