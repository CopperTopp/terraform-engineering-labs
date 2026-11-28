output "gateway_id" {
  description = "Generated ID of the gateway component."

  value = module.gateway.id
}

output "gateway_settings" {
  description = "Settings for the gateway component."

  value = module.gateway.settings
}