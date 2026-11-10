variable "vpc_cidr_block" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "environment" {
  description = "Environment name used in network resource tags."
  type        = string
}

variable "lab_subnets" {
  description = "Subnet definition keyed by Availability Zone suffix."

  type = map(object({
    cidr_block = string
  }))
}

module "network" {
  source = "./modules/network"

  vpc_cidr_block = var.vpc_cidr_block
  environment    = var.environment
  lab_subnets    = var.lab_subnets
}

output "voc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}