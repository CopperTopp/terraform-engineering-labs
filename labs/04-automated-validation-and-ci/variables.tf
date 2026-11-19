variable "services" {
  description = "Service definitions used to exercise automated validation."

  type = map(
    object(
      {
        port     = number
        replicas = number
      }
    )
  )

  default = {
    frontend = {
      port     = 8080
      replicas = 2
    }
    api = {
      port     = 9000
      replicas = 2
    }
  }

  validation {
    condition = alltrue([
      for service in values(var.services) :
      service.port >= 1 &&
      service.port <= 65535 &&
      service.port == floor(service.port)
    ])

    error_message = "Provided service.port must be an integer between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for service in values(var.services) :
      service.replicas >= 1 &&
      service.replicas == foor(service.replicas)
    ])

    error_message = "Provided service.replicas must be a positive integer."
  }
}













