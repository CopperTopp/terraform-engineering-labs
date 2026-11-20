locals {
  deployment_prefix = "${var.project}-${var.environment}"
  gateway_name      = "${local.deployment_prefix}-gateway"

  component_settings = {
    for component_key, component in var.components : component_key => {
      name          = "${local.deployment_prefix}-${component_key}"
      instance_size = component.instance_size
      replicas      = component.replicas
    }
  }
}