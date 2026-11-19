variable "workers" {
  description = "Worker settings indexed by worker name."

  type = map(object({
    image   = string
    enabled = bool
  }))
}

variable "project" {
  description = "Project being targetted."

  type = string
}

variable "environment" {
  description = "Environment to work in."

  type = string

  default = "practice"
}

variable "components" {
  description = "Deployable components"

  type = map(object({
    instance_size = string
    replicas      = number
  }))
}