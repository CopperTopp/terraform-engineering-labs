locals {
  lab_subnets = {
    for key, subnet in var.lab_subnets : key => {
      cidr_block = subnet.cidr_block
      availability_zone = one([
        for az_name in data.aws_availability_zones.available.names :
        az_name
        if endswith(az_name, key)
      ])
    }
  }
}