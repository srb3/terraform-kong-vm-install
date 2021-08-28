# terraform-kong-vm-install

A terraform module for installing Kong gateway
onto virtual machines or bear metal servers.
Pass the module the address and ssh credentials
of the target you want to install Kong on.
Under the hood this module calls the Ansible role
for installing [Kong](https://github.com/srb3/ansible-role-kong-gateway)

## Usage

### Using module defaults

The following will install Kong on a VM
that has previously been created

```HCL
# gernerate certificates for hybrid mode
module "tls" {
  source   = "srb3/cluster-tls/kong"
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
...
...
...
# example of usage
module "kong-install" {
  source               = "srb3/vm-install/kong"
  hosts                = [module.ec2_instance.public_ip]
  ssh_user_name        = "ec2-user"
  ssh_user_private_key = "~/.ssh/id_rsa"
  cluster_cert         = module.tls.cert.kong-cluster.cert_pem
  cluster_cert_key     = module.tls.key.kong-cluster.private_key_pem
  kong_config          = local.kong_config
}
```

## Testing

No testing yet
