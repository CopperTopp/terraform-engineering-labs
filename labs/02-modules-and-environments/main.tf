variable "lab_subnets" {
  description = "Subnet definition keyed by Availability Zone suffix."

  type = map(object({
    cidr_block = string
  }))
}

module "network" {
  source = "./modules/network"

  lab_subnets = var.lab_subnets
}

output "voc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}