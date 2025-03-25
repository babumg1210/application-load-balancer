provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "this" {
  for_each = var.subnet_details
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.key
  }
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "route-public-igw"
  }
}

# Only associate public subnets with the route table
resource "aws_route_table_association" "public" {
  for_each = {
    for key, subnet in aws_subnet.this : key => subnet
    if subnet.map_public_ip_on_launch == true
  }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = var.vpc_enable_nat_gateway ? 1 : 0
  domain = "vpc"  # Use domain instead of vpc

   tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "private" {
  count          = var.vpc_enable_nat_gateway ? 1 : 0
  depends_on     = [aws_eip.nat]
  allocation_id  = aws_eip.nat[count.index].id  # Correctly reference the EIP instance
  subnet_id      = element([for s in aws_subnet.this : s.id if s.map_public_ip_on_launch == true], 0)  # Select the first public subnet
  tags = {
    Name = "nat-gateway-private"
  }
}

resource "aws_route_table" "private" {
  for_each = {
    for key, subnet in aws_subnet.this : key => subnet
    if subnet.map_public_ip_on_launch == false  # Only private subnets
  }

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private[*].id, 0)  # Select the first NAT Gateway from the list
  }

  tags = {
    Name = "${each.key}-route"
  }
}
