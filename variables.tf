variable "hosts" {
  type    = list(string)
  default = []
}

variable "cluster_cert" {
  description = "The content of the cluster cert for mtls"
  type        = string
  default     = ""
}

variable "cluster_cert_key" {
  description = "The content of the cluster key for mtls"
  type        = string
  default     = ""
}

variable "kong_config" {
  description = "A map of strings setting out the Kong gateway configuration"
  type        = map(string)
  default     = {}
}

variable "ssh_user_name" {
  description = "The ssh user name of the kong instance"
  type        = string
}

variable "ssh_user_private_key" {
  description = "The ssh user private key of the kong instance"
  type        = string
}

variable "extra_vars" {
  description = "A map of extra variables to pass to the ansible playbook command"
  type        = map(any)
  default     = {}
}
