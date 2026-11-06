variable "lab_subnets" {
  description = "Subnet definitions keyed by stable logical identifiers."

  type = map(object({
    cidr_block = string
    az_index   = number
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
      for subnet in values(var.lab_subnets) :
      try(
        subnet.az_index >= 0 && subnet.az_index == floor(subnet.az_index),
        false
      )
    ])

    error_message = "Each subnet az_index must be a non-negative whole number."
  }

  validation {
    condition = alltrue([
      for subnet in values(var.lab_subnets) :
      try(
        subnet.az_index < length(data.aws_availability_zones.available.names),
        false
      )
    ])

    error_message = "Each subnet az_index must be less than the number of Availability Zones, currently [${length(data.aws_availability_zones.available.names)}]"
  }
}