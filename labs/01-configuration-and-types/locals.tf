locals {
    lab_subnets = {
        a = {
            cidr_block = "10.0.1.0/24"
            availability_zone = data.aws_availability_zones.available.names[0]
        }
        b = {
            cidr_block = "10.0.2.0/24"
            availability_zone = data.aws_availability_zones.available.names[1]
        }
    }
}