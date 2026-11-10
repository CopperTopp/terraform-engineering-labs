variable "vpc_cidr_block" {
  description = "IPv4 CIDR Block for the VPC."
  type        = string
}

variable "environment" {
  description = "Environment name used in network resource tags."
  type        = string
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
    error_message = "Each subnet must have a valid IPv4 CIDR Block."
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

    error_message = "Each subnet key must match an existing Availability Zone's lettered suffix. (ex. 'a' for 'us-east-2a')"
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

    error_message = "Invalid subnet key returned too many results."
  }
}