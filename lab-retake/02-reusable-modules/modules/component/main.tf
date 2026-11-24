resource "terraform_data" "this" {
  input = {
    name          = var.component_name
    instance_size = var.instance_size
    replicas      = var.replicas
  }
}
