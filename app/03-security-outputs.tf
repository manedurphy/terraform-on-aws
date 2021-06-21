# Bastion Security Group ID, VPC ID, and Name
output "bastion_security_group_info" {
  description = "ID, VPC ID, and name for bastion host"
  value = {
    id     = module.bastion_host_sg.security_group_id
    vpc_id = module.bastion_host_sg.security_group_vpc_id
    name   = module.bastion_host_sg.security_group_name
  }
}

# Private Subnet Security Group ID, VPC ID, and Name
output "private_subnet_security_group_info" {
  description = "ID, VPC ID, and name for private subnet"
  value = {
    id     = module.private_sg.security_group_id
    vpc_id = module.private_sg.security_group_vpc_id
    name   = module.private_sg.security_group_name
  }
}

# Classic Loadbalancer Security Group ID, VPC ID, and Name
output "classic_loadbalancer_security_group_info" {
  description = "ID, VPC ID, and name for classic loadbalancer"
  value = {
    id     = module.loadbalancer_sg.security_group_id
    vpc_id = module.loadbalancer_sg.security_group_vpc_id
    name   = module.loadbalancer_sg.security_group_name
  }
}

