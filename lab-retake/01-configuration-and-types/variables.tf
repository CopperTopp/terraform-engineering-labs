variable "project" {
  description = "Project being targetted."

  type = string
}

variable "environment" {
  description = "Environment to work in."

  type = string

  # Validate "environment" is only one of "practice", "review", or "production"
  validation {
    condition = contains(["practice", "review", "production"], var.environment)

    error_message = "environment was set to ${var.environment}, but must be one of 'practice', 'review', or 'production'."
  }

}

variable "components" {
  description = "Deployable components"

  type = map(object({
    instance_size = string
    replicas      = number
  }))

  validation {
    # Check that replicas attribute is an integer between 1 and 5.
    condition = alltrue(
      [
        for comp in var.components : comp.replicas >= 1 && comp.replicas <= 5 && floor(comp.replicas) == comp.replicas
      ]
    )
    error_message = "replicas attribute must be an integer between 1 and 5, found incorrect values ${join(", ",
      [
        for key, comp in var.components : "${key}.replicas = ${comp.replicas}"
        if comp.replicas < 1 ||
        comp.replicas > 5 ||
        floor(comp.replicas) != comp.replicas
      ]
    )}."
  }
}