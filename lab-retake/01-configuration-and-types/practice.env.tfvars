environment = "practice"
project     = "parcel"

components = {
  gateway = {
    instance_size = "small"
    replicas      = 2
  }
  processor = {
    instance_size = "medium"
    replicas      = 4
  }
  scheduler = {
    instance_size = "small"
    replicas      = 1
  }
}