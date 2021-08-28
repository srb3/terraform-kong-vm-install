# terraform-kong-vm-install

A terraform module for installing Kong gateway
onto virtual machines or barmetal servers.
Pass the module the address and ssh credentials
of the target you want to install kong on.
Under the hood this module calls the Ansible role
for installing [kong](https://github.com/srb3/ansible-role-kong-gateway)

## Usage

### Using module defaults

The following will create the correctly formed
certificate and key to use with all instances of
a Kong cluster using shared mode clustering

```HCL
# gernerate certificates for hybrid mode
module "tls" {
  source   = "srb3/cluster-tls/kong"
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

no testing yet
