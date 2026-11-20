resource "terraform_data" "component" {
  for_each = local.component_settings
  input    = each.value
}
