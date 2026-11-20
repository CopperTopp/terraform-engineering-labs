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
}