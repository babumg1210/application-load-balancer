# Data source to get the AMI ID for Amazon Linux 2
data "aws_ami" "amzlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


provider "aws" {
  region = var.aws_region
}

# VPC Module: Creates VPC and subnets
module "vpc" {
  source         = "./modules/VPC"
  aws_region     = var.aws_region
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  subnet_details = var.subnet_details
}

# Security Groups Module: Handles private security groups
module "private_sg" {
  source = "./modules/Security_Groups"
  
  # Pass the VPC ID from the VPC module
  vpc_id = module.vpc.vpc_id

  # Pass only private subnets filtered dynamically
  subnet_details = {
    for k, v in var.subnet_details : k => v if v.public == false
  }
}

# Order Services EC2 Module
module "order_services" {
  for_each          = var.services_map

  source            = "./modules/EC2"
  service_name      = each.key
  instance_count    = each.value.instance_count
  ami_id            = data.aws_ami.amzlinux2.id
  instance_type     = each.value.instance_type
  subnet_id         = module.vpc.subnet_details["Order"].id
  security_group_ids = [module.private_sg.private_security_group_ids["Order"]]
  common_tags       = var.common_tags
  services_map = var.services_map
}

# Auth Services EC2 Module
module "auth_services" {
  for_each          = var.services_map

  source            = "./modules/EC2"
  service_name      = each.key
  instance_count    = each.value.instance_count
  ami_id            = data.aws_ami.amzlinux2.id
  instance_type     = each.value.instance_type
  subnet_id         = module.vpc.subnet_details["Auth"].id
  security_group_ids = [module.private_sg.private_security_group_ids["Auth"]]
  common_tags       = var.common_tags
  services_map = var.services_map
}