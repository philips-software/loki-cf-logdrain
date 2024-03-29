variable "docker_tag" {
  type    = string
  default = "latest"
}

variable "memory" {
  type    = number
  default = 256
}

variable "cf_domain" {
  description = "The CF domain to create the route in."
  type        = string
}
variable "cf_space_id" {
  description = "The CF space id to deploy into."
  type        = string
}

variable "name_postfix" {
  description = "The name postfix to apply"
  type        = string
}

variable "disk" {
  description = "The amount of Disk space to allocate for Grafana Loki (MB)"
  type        = number
  default     = 1024
}

variable "loki_password" {
  description = "The Loki password used for basic auth."
  type        = string
  sensitive   = true
  default     = ""
}

variable "loki_username" {
  description = "The Loki username used for basic auth. Default: loki"
  type        = string
  default     = ""
}

variable "loki_push_endpoint" {
  description = "The Loki push endpoint. This should include /loki/api/v1/push"
  type        = string
}

variable "docker_registry_image" {
  description = "The Docker registry image to use."
  type        = string
  default     = "ghcr.io/philips-software/loki-cf-logdrain"
}

variable "loki_network_policy" {
  description = "Network policy configuration in case the Loki is running on CF"
  type = object({
    app_id = string
    port   = string
  })
  default = {
    app_id = ""
    port   = 3100
  }
}
