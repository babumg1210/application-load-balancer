aws_region = "us-west-2"

vpc_cidr = "192.168.0.0/16"

vpc_name = "affiliate-vpc"

subnet_details = {
  "Order" = {
    cidr   = "192.168.2.0/24",
    public = false,
    az     = "us-west-2b"
  }
  "Auth" = {
    cidr   = "192.168.3.0/24",
    public = false,
    az     = "us-west-2c"
  }
  "Public Subnet" = {
    cidr   = "192.168.6.0/24",
    public = true,
    az     = "us-west-2c"
  }
}

services_map = {
  auth_server = {
    instance_count = 2
    instance_type  = "t3.micro"
    memory         = "1 GB"
    vcpu           = 1
    storage        = "8 GB"
    #subnet_id          = module.vpc.subnet_details["Auth"].id // Ensure this is a valid reference
    #security_group_ids = [module.private_sg.private_security_group_ids["auth"]] // Ensure this is a valid reference
  }
  Order_server = {
    instance_count = 2
    instance_type  = "t3.micro"
    memory         = "1 GB"
    vcpu           = 1
    storage        = "8 GB"
  } 
}