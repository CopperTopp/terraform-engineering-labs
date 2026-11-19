output "service_definitions" {
  description = "Service definitions indexed by service name."

  value = {
    for name, service in terraform_data.service : name => service.input
  }
}