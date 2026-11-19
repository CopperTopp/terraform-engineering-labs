resource "terraform_data" "gateway" {
  input = {
    name          = local.gateway_name
    instance_size = var.components.gateway.instance_size
    replicas      = var.components.gateway.replicas
  }
}