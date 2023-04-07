variable "do_token" {}
#variable "ssh_private_key" {
#  description = "Enter path to your ssh private key"
#  type        = string
#  #default     = "storemez"
#  nullable = false
#  validation {
#    condition     = length(var.ssh_private_key) > 0
#    error_message = "The ssh_private_key value must be a path to key"
#  }
#}
variable "dorplet_ver" {
  type    = string
  default = "ubuntu-22-10-x64"
}

#variable "ssh_pub_key" {
#  description = "Enter path to your ssh public key"
#  type        = string
#  #default     = "./storemez.pub"
#  validation {
#    condition     = length(var.ssh_pub_key) > 0
#    error_message = "The ssh_pub_key value must be a path to key"
#  }
#}
