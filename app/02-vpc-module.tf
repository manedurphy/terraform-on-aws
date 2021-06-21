module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.1.0"

  name = local.vpc_name
  cidr = var.vpc_cidr_block

  # VPC Basic Config
  azs             = var.vpc_availability_zones
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  # Database
  database_subnets                       = var.vpc_database_subnets
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false # Set to true for public access

  # One NAT Gateway per AZ
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Type = "Public Subnets"
  }

  private_subnet_tags = {
    Type = "Private Subnets"
  }

  database_subnet_tags = {
    Type = "Private Database Subnets"
  }

  tags = {
    Environment = var.environment
  }

  vpc_tags = {
    Name = local.vpc_name
  }
}
