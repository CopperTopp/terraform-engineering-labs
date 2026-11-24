variable "component_name" {
  description = "Name of the Component."

  type = string
}

variable "instance_size" {
  description = "Size of the Instance used by the Component."
  type        = string

  validation {
    condition = contains(["small", "medium", "large"], var.instance_size)

    error_message = "instance_size attribute set to ${var.instance_size}, but must be one of 'small', 'medium', or 'large'."
  }
}

variable "replicas" {
  description = "Desired Replica count."

  type = number

  validation {
    condition     = var.replicas >= 1 && var.replicas <= 5 && floor(var.replicas) == var.replicas
    error_message = "replicas attribute set to ${var.replicas}, but must be a whole number in the range 1 to 5."
  }
}