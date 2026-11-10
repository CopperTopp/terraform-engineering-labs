vpc_cidr_block = "10.0.0.0/16"
environment    = "lab"

lab_subnets = {
  a = {
    cidr_block = "10.0.1.0/24"
  }
  b = {
    cidr_block = "10.0.2.0/24"
  }
  c = {
    cidr_block = "10.0.3.0/24"
  }
}
