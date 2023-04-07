#### Describe provider
locals {
  ssh_filename = "usa"
}

provider "digitalocean" {
  token = var.do_token
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

### Import SSH key or Use existing key in DO
resource "digitalocean_ssh_key" "default" {
  name       = "My_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

### Create new VM
resource "digitalocean_droplet" "VM1" {
  image    = var.dorplet_ver
  name     = "wg"
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["wg"]

}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      ip_name      = digitalocean_droplet.VM1.ipv4_address
      droplet_name = digitalocean_droplet.VM1.name
    }
  )
  filename   = "${path.module}/ansible/inventory"
  depends_on = [digitalocean_droplet.VM1]
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [local_file.inventory]

  create_duration = "30s"
}
resource "local_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${local.ssh_filename}.pem")
  file_permission      = "600"
  directory_permission = "700"
  sensitive_content    = tls_private_key.ssh_key.private_key_pem
}

resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -u root -i ansible/inventory --ssh-common-args='-o StrictHostKeyChecking=no' --private-key ~/.ssh/${local.ssh_filename}.pem ansible/wg_up.yml"

  }
  depends_on = [time_sleep.wait_30_seconds]
}
