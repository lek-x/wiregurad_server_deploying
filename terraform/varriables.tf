#variable "do_token" {}

variable "image" {
  type    = string
  default = "ubuntu"
}

variable "region" {
  type    = string
  default = "eu"
}

variable "size" {
  type    = string
  default = "s-1vcpu-1gb"
}

variable "root_pass" {
  type = string
  # sensitive = true
}
