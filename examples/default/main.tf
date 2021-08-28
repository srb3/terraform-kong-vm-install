provider "libvirt" {
  uri = "qemu:///system"
}

module "tls" {
  source  = "srb3/cluster-tls/kong"
  version = "0.0.2"
}

module "kong" {
  source                     = "srb3/domain/libvirt"
  version                    = "0.0.1"
  hostname                   = "kong-1"
  user                       = "kong"
  ssh_public_key             = "~/.ssh/id_rsa.pub"
  os_name                    = "centos"
  os_version                 = "8"
  os_cached_image            = var.os_cached_image
  unique_libvirt_domain_name = false
}

output "kong_cp" {
  value = module.kong
}

locals {
  kong_config = {
    "role"                        = "control_plane"
    "lua_ssl_trusted_certificate" = "/etc/secrets/kong-cluster/tls.crt"
    "cluster_mtls"                = "shared"
    "log_level"                   = "debug"
    "admin_access_log"            = "logs/admin_access.log"
    "admin_error_log"             = "logs/error.log"
    "admin_gui_auth"              = "basic-auth"
    "enforce_rbac"                = "on"
    "admin_gui_session_conf"      = "{}"
    "admin_listen"                = "127.0.0.1:8001"
    "admin_gui_listen"            = "off"
    "cluster_listen"              = "0.0.0.0:443 ssl"
    "cluster_telemetry_listen"    = "0.0.0.0:3128 ssl"
    "status_listen"               = "0.0.0.0:8100"
    "portal"                      = "off"
    "stream_listen"               = "off"
    "anonymous_reports"           = "off"
    "database"                    = "postgres"
    "pg_database"                 = "d-uk-kong-dev"
    "pg_password"                 = "password"
    "pg_user"                     = "kong"
    "pg_host"                     = "127.0.0.1"
    "vitals_strategy"             = "database"
    "vitals"                      = "off"
  }
}

module "kong-install" {
  source               = "../../"
  hosts                = [module.kong.ip]
  ssh_user_name        = "kong"
  ssh_user_private_key = "~/.ssh/id_rsa"
  cluster_cert         = module.tls.cert.kong-cluster.cert_pem
  cluster_cert_key     = module.tls.key.kong-cluster.private_key_pem
  kong_config          = local.kong_config
}
