vpc_cidr_block = "10.1.0.0/16"
environment    = "test"

lab_subnets = {
  a = {
    cidr_block = "10.1.1.0/24"
  }
  b = {
    cidr_block = "10.1.2.0/24"
  }
}
