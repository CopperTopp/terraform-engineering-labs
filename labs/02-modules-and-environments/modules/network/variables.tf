locals {
  valid_environment_names = ["lab","test","stage","prod"]
}

variable "vpc_cidr_block" {
  description = "IPv4 CIDR Block for the VPC."
  type        = string

  validation {
    condition = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "vpc_cidr_block set to ${jsonencode(var.vpc_cidr_block)}, must be a valid IPv4 CIDR block, such as 10.0.0.0/16. "
  }
}

variable "environment" {
  description = "Environment name used in network resource tags."
  type        = string

  validation {
    condition = contains(local.valid_environment_names, var.environment)
    error_message = "Invalid environment value ${jsonencode(var.environment)}, must be one of: ${join(", ", local.valid_environment_names)}."
  }
}

variable "lab_subnets" {
  description = "Subnet definitions keyed by stable logical identifiers."

  type = map(object({
    cidr_block = string
  }))

  validation {
    condition = alltrue([
      for subnet in values(var.lab_subnets) :
      can(cidrnetmask(subnet.cidr_block))
    ])
    error_message = "Each subnet must have a valid IPv4 CIDR Block, Invalid Blocks: ${join(". ", [
      for key,subnet in values(var.lab_subnets) : "${key} has CIDR ${subnet.cidr_block}"
      if !can(cidernetmask(subnet.cidr_block))
    ])}."
  }

  validation {
  condition = alltrue([
    for key in keys(var.lab_subnets) :
    length([
      for az_name in data.aws_availability_zones.available.names :
      az_name
      if endswith(az_name, key)
    ]) >= 1
  ])

  error_message = "Subnet keys with no matching Availability Zone: ${join(", ", [
    for key in keys(var.lab_subnets) :
    key
    if length([
      for az_name in data.aws_availability_zones.available.names :
      az_name
      if endswith(az_name, key)
    ]) == 0
  ])}."
  }

  validation {
    condition = alltrue([
      for key in keys(var.lab_subnets) :
      length([
        for az_name in data.aws_availability_zones.available.names :
        az_name
        if endswith(az_name, key)
      ]) <= 1
    ])

    error_message = "Subnet keys with multiple Availability Zone matches: ${join("; ", [
      for key in keys(var.lab_subnets) :
      "${key} -> [${join(", ", [
        for az_name in data.aws_availability_zones.available.names :
        az_name
        if endswith(az_name, key)
      ])}]"
      if length([
        for az_name in data.aws_availability_zones.available.names :
        az_name
        if endswith(az_name, key)
      ]) > 1
    ])}."
  }
}