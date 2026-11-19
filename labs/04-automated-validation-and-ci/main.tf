resource "terraform_data" "service" {
  for_each = var.services

  input = {
    name     = each.key
    port     = each.value.port
    replicas = each.value.replicas
  }
}
