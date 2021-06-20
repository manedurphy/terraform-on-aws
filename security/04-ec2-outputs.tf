output "ami_info" {
  description = "AMI information for EC2"
  value = {
    id   = data.aws_ami.ubuntu.id
    name = data.aws_ami.ubuntu.name
  }
}

# Public
output "ec2_bastion_info" {
  description = "Information on Bastion Hosts"
  value = {
    instance_ids       = module.ec2_bastion.id
    availability_zones = module.ec2_bastion.availability_zone
    public_ips         = module.ec2_bastion.public_ip
    eip = aws_eip.bastion_eip.public_ip
  }
}

# Private
output "ec2_private_info" {
  description = "Information on Private VMs"
  value = {
    instance_ids       = module.ec2_private.id
    availability_zones = module.ec2_private.availability_zone
    private_ips        = module.ec2_private.private_ip
  }
}
