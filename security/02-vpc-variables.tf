variable "vpc_cidr_block" {
  type = string
}

variable "vpc_availability_zones" {
  type = list(string)
}

variable "vpc_public_subnets" {
  type = list(string)
}

variable "vpc_private_subnets" {
  type = list(string)
}

variable "vpc_database_subnets" {
  type = list(string)
}
