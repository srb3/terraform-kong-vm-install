variable "private_key_algorithm" {
  default = "ECDSA"
}

variable "private_key_ecdsa_curve" {
  default = "P384"
}

variable "private_key_rsa_bits" {
  default = "2048"
}

variable "validity_period_hours" {
  default = "8760"
}

variable "ca_allowed_uses" {
  default = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

variable "ca_common_name" {
  default = "kong_clustering"
}

variable "override_common_name" {
  default = "kong_clustering"
}

variable "host_suffix" {
  default = null
}

variable "certificates" {
  type = map(object({
    common_name  = string
    dns_names    = list(string)
    allowed_uses = list(string)
  }))
  default = {
    "kong-cluster" = {
      common_name  = "kong_clustering"
      allowed_uses = null
      dns_names    = []
    }
  }
}
