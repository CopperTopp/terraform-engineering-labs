terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "drift_demo" {
  filename = "${path.module}/.terraform/drift-demo.txt"
  content = "Mangfed by Terraform."
}