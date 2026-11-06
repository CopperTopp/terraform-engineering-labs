locals {
  lab_subnets = {
    for key, subnet in var.lab_subnets : key => {
      cidr_block = subnet.cidr_block
      availability_zone = (
        data.aws_availability_zones.available.names[subnet.az_index]
      )
    }
  }
}