resource "aws_security_group" "private_sg" {
  for_each    = var.subnet_details  # Iterate over the passed private subnets
  name        = "private-sg-${each.key}"
  description = "Private security group for ${each.key} subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow HTTP traffic within the VPC (adjust based on your needs)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "Private Security Group for ${each.key}"
  }
}