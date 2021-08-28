# this module will be removed when cert manager
# is implemented

resource "tls_private_key" "this-ca" {
  algorithm   = var.private_key_algorithm
  ecdsa_curve = var.private_key_ecdsa_curve
  rsa_bits    = var.private_key_rsa_bits
}

resource "tls_self_signed_cert" "this-ca" {
  key_algorithm     = tls_private_key.this-ca.algorithm
  private_key_pem   = tls_private_key.this-ca.private_key_pem
  is_ca_certificate = true

  validity_period_hours = var.validity_period_hours
  allowed_uses          = var.ca_allowed_uses

  subject {
    common_name  = var.override_common_name != null ? var.override_common_name : var.ca_common_name
    organization = "kong"
  }
}

resource "tls_private_key" "this-key" {
  for_each    = var.certificates
  algorithm   = var.private_key_algorithm
  ecdsa_curve = var.private_key_ecdsa_curve
  rsa_bits    = var.private_key_rsa_bits
}

resource "tls_cert_request" "this-cert-request" {
  for_each = var.certificates

  key_algorithm   = tls_private_key.this-key[each.key].algorithm
  private_key_pem = tls_private_key.this-key[each.key].private_key_pem

  subject {
    common_name  = each.value.common_name
    organization = "kong"
  }
  dns_names = each.value.dns_names
}

resource "tls_locally_signed_cert" "this-cert" {
  for_each         = var.certificates
  cert_request_pem = tls_cert_request.this-cert-request[each.key].cert_request_pem

  ca_key_algorithm   = tls_private_key.this-ca.algorithm
  ca_private_key_pem = tls_private_key.this-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.this-ca.cert_pem

  validity_period_hours = var.validity_period_hours
  allowed_uses          = each.value.allowed_uses != null ? each.value.allowed_uses : []
}
