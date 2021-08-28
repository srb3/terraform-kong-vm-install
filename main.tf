locals {

  conf = templatefile("${path.module}/templates/vars", {
    config           = var.kong_config
    cluster_cert     = var.cluster_cert
    cluster_cert_key = var.cluster_cert_key
  })

  roles = [
    "srb3.kong_gateway"
  ]

  hosts = {
    "kong_gateway" = {
      role            = "srb3.kong_gateway"
      hosts           = var.hosts
      vars            = local.conf
      ssh_user        = var.ssh_user_name
      ssh_private_key = var.ssh_user_private_key
    }
  }
}

module "role" {
  source  = "srb3/role/ansible"
  version = "0.0.4"
  roles   = local.roles
  hosts   = local.hosts
}
