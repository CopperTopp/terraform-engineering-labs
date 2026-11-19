workers = {
  reporting = {
    image   = "worker-v1"
    enabled = true
  }
}

project = "parcel"

components = {
  gateway = {
    instance_size = "small"
    replicas      = 2
  }
  processor = {
    instance_size = "medium"
    replicas      = 3
  }
}