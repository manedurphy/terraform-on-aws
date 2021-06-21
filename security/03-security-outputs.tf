# Bastion Security Group ID
output "bastion_security_group_id" {
  description = "Id for bastion host security group"
  value       = module.bastion_host_sg.security_group_id
}

# Bastion Security Group VPC ID
output "bastion_security_group_vpc_id" {
  description = "Id for bastion host security group VPC ID"
  value       = module.bastion_host_sg.security_group_vpc_id
}

# Bastion Security Group VPC Name
output "bastion_security_group_name" {
  description = "Id for bastion host security group VPC name"
  value       = module.bastion_host_sg.security_group_name
}

# Private Subnet Security Group ID
output "private_security_group_id" {
  description = "Id for bastion host security group"
  value       = module.private_sg.security_group_id
}

# Private Security Group VPC ID
output "private_group_vpc_id" {
  description = "Id for bastion host security group VPC ID"
  value       = module.private_sg.security_group_vpc_id
}

# Private Security Group VPC Name
output "private_group_name" {
  description = "Id for bastion host security group VPC name"
  value       = module.private_sg.security_group_name
}
