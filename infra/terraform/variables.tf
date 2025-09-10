variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

# These will be filled later from the created GKE cluster (or passed in)
variable "kube_host" {
  type    = string
  default = ""
}

variable "kube_token" {
  type    = string
  default = ""
}

variable "kube_ca_cert" {
  type    = string
  default = ""
}

# Image tags for promotion (used after charts exist)
variable "backend_tag" {
  type    = string
  default = "dev"
}

variable "frontend_tag" {
  type    = string
  default = "dev"
}
