output "gateway_id" {
  description = "Gateway Instance Identifier"

  value = terraform_data.component["gateway"].id
}

output "gateway_name" {
  description = "Name of the Gateway Instance"

  value = terraform_data.component["gateway"].output.name
}

output "gateway_settings" {
  description = "Gateway Instance Settings"

  value = terraform_data.component["gateway"].output
}

output "component_inventory" {
  description = "Inventory of existing components."

  value = {
    for key, comp in terraform_data.component : key => {
      id            = comp.id
      name          = comp.output.name
      instance_size = comp.output.instance_size
      replicas      = comp.output.replicas
    }
  }
}

output "scaled_components" {
  description = "Components with replics > 1, keyed in a map by their replica value."

  value = {
    for key, comp in terraform_data.component : key => comp.output.replicas if comp.output.replicas > 1
  }
}