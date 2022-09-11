variable "do_token" {}
variable "ssh_pub_key" {
  description = "type your pub key name"
  type        = string
  default     = "./storemez.pub"
}
variable "dorplet_ver" {
  type    = string
  default = "ubuntu-22-04-x64"
}