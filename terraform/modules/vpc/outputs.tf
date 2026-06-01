output "vpc_id" {
  description = "ID of the VPC"
  value       = module.this.vpc_id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.this.private_subnets
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.this.public_subnets
}