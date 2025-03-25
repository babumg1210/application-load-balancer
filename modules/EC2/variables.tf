variable "services_map" {
  description = "Details for each service"
  type = map(object({
    instance_count   = number          # Number of instances to be created for each service
    instance_type    = string          # EC2 instance type (e.g., "t3.micro")
    memory           = string          # Memory (e.g., "1 GB")
    vcpu             = number          # Number of vCPUs (e.g., 2)
    storage          = string          # Storage type (e.g., "20 GB")
    #subnet_id        = string          # Subnet ID where EC2 instances will be launched
    #security_group_ids = list(string)  # Security group IDs to associate with the EC2 instances
  }))
}

variable "service_name" {
  description = "The name of the service"
  type        = string
}

variable "instance_count" {
  description = "The number of instances to create"
  type        = number
}

variable "ami_id" {
  description = "The AMI ID to use for instances"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID for the EC2 instances"
  type        = string
}

variable "security_group_ids" {
  description = "The security group IDs to assign to the EC2 instances"
  type        = list(string)
}

variable "common_tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}