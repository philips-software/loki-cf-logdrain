locals {
  create_network_policy = var.loki_network_policy.app_id != ""
}

resource "random_password" "token" {
  length  = 32
  special = false
}

resource "cloudfoundry_app" "loki_cf_logdrain" {
  name         = "tf-loki-logdrain-${var.name_postfix}"
  space        = var.cf_space_id
  memory       = var.memory
  disk_quota   = var.disk
  docker_image = "${var.docker_registry_image}:${var.docker_tag}"
  environment = merge({
    TOKEN = random_password.token.result
    PROMTAIL_YAML_BASE64 = base64encode(templatefile("${path.module}/templates/promtail.yaml", {
      loki_push_endpoint = var.loki_push_endpoint
      username           = var.loki_username
      password           = var.loki_password
    }))
  }, {})
  strategy = "rolling"

  //noinspection HCLUnknownBlockType
  routes {
    route = cloudfoundry_route.loki_cf_logdrain.id
  }
}

resource "cloudfoundry_route" "loki_cf_logdrain" {
  domain   = data.cloudfoundry_domain.domain.id
  space    = var.cf_space_id
  hostname = "tf-loki-logdrain-${var.name_postfix}"
}

resource "cloudfoundry_user_provided_service" "logdrain" {
  name  = "tf-loki-logdrain-${var.name_postfix}"
  space = var.cf_space_id
  //noinspection HILUnresolvedReference
  syslog_drain_url = "https://${cloudfoundry_route.loki_cf_logdrain.endpoint}/syslog/drain/${random_password.token.result}"
}

resource "cloudfoundry_network_policy" "loki" {
  count = local.create_network_policy ? 1 : 0

  policy {
    source_app      = cloudfoundry_app.loki_cf_logdrain.id
    destination_app = var.loki_network_policy.app_id
    protocol        = "tcp"
    port            = var.loki_network_policy.port
  }
}
