# Terraform Output Values
/* Concepts Covered
1. For Loop with List
2. For Loop with Map
3. For Loop with Map Advanced
4. Legacy Splat Operator (latest) - Returns List
5. Latest Generalized Splat Operator - Returns the List
6. 
*/

# Output - For Loop with List
output "for_output_list" {
  description = "For Loop with List"
  value       = [for instance in aws_instance.myec2vm : instance.public_dns]
}

# Output - For Loop with Map
output "for_output_map1" {
  description = "For Loop with Map"
  value       = { for instance in aws_instance.myec2vm : instance.id => instance.public_dns }
}

# Output - For Loop with Map Advanced
output "for_output_map2" {
  description = "For Loop with Map - Advanced"
  value       = { for c, instance in aws_instance.myec2vm : c => instance.public_dns }
}

# Output Legacy Splat Operator (Legacy) - Returns the List
/*
output "legacy_splat_instance_publicdns" {
  description = "Legacy Splat Operator"
  value = aws_instance.myec2vm.*.public_dns
}
*/

# Output Latest Generalized Splat Operator - Returns the List
# output "latest_splat_instance_publicdns" {
#   description = "Generalized latest Splat Operator"
#   value       = aws_instance.myec2vm[*].public_dns
# }

# Output array of EC2 type offerings map
output "azone_instance_types_map" {
  #   value = data.aws_ec2_instance_type_offerings.my_instance_types.instance_types
  value = { for az, types in data.aws_ec2_instance_type_offerings.my_instance_types : az => types.instance_types if length(types.instance_types) != 0 }
}

# Output array of EC2 type offerings keys (availability zones)
output "azones_that_support_instance_type" {
  #   value = data.aws_ec2_instance_type_offerings.my_instance_types.instance_types
  value = keys({ for az, types in data.aws_ec2_instance_type_offerings.my_instance_types : az => types.instance_types if length(types.instance_types) != 0 })
}
