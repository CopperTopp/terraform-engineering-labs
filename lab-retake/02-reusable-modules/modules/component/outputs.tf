output "id" {
  description = "Component's generated id."

  value = terraform_data.this.id
}

output "settings" {
  description = "Component's settings."

  value = terraform_data.this.output
}