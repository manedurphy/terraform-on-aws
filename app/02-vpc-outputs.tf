# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR
output "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  value       = module.vpc.vpc_cidr_block
}

# PUBLIC SUBNETS
output "public_subnets" {
  description = "List of public subnet Ids"
  value       = module.vpc.public_subnets
}

# PRIVATE SUBNETS
output "private_subnets" {
  description = "List of private subnet Ids"
  value       = module.vpc.private_subnets
}

# VPC NAT gateway Public IP
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# DATABASE SUBNETS
output "database_subnets" {
  description = "List of private subnet Ids for databases"
  value       = module.vpc.database_subnets
}
