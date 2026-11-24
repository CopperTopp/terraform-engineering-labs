module "gateway" {
  source = "./modules/component"

  component_name = "parcel-practice-gateway"
  instance_size  = "small"
  replicas       = 2
}