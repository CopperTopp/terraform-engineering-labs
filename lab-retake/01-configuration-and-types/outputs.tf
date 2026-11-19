output "gateway_id" {
  description = "Gateway Instance Identifier"

  value = terraform_data.gateway.id
}

output "gateway_name" {
  description = "Name of the Gateway Instance"

  value = terraform_data.gateway.output.name
}

output "gateway_settings" {
  description = "Gateway Instance Settings"

  value = terraform_data.gateway.output
}