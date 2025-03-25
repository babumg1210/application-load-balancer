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

resource "aws_instance" "service_instance" {
  for_each = var.services_map  # Using for_each to create multiple instances

  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = each.value.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  
  tags = merge(
    var.common_tags,
    { Name = "${each.key}-${each.value.instance_count}" }
  )

  # Optional: EBS Block Device
  ebs_block_device {
    device_name           = "/dev/sdh"
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }
}

