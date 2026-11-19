locals {
  deployment_prefix = "${var.project}-${var.environment}"
  gateway_name      = "${local.deployment_prefix}-gateway"
}