#### Describe provider
locals {
  ssh_filename = "key"
  region       = (var.region == "usa" ? "nyc1" : (var.region == "eu" ? "fra1" : "lon1"))
  image        = (var.image == "ubuntu" ? "ubuntu-23-10-x64" : "rockylinux-9-x64")
  size         = (var.size == "1" ? "s-1vcpu-1gb" : (var.size == "2" ? "s-2vcpu-4gb" : "s-1vcpu-1gb"))
}

# provider "digitalocean" {
#   token = var.do_token
# }

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

### Import SSH key or Use existing key in DO
resource "digitalocean_ssh_key" "default" {
  name       = "wg_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

### Create new VM
resource "digitalocean_droplet" "VM1" {
  image    = local.image
  name     = "wg-server"
  region   = local.region
  size     = local.size
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags     = ["wireguard"]

}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      ip_name      = digitalocean_droplet.VM1.ipv4_address
      droplet_name = digitalocean_droplet.VM1.name
    }
  )
  filename   = "${path.module}/../ansible/ansible-inventory"
  depends_on = [digitalocean_droplet.VM1]
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [local_file.inventory]

  create_duration = "30s"
}
resource "local_sensitive_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${local.ssh_filename}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.ssh_key.private_key_pem
}

resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -i ../ansible/ansible-inventory  -u root --ssh-common-args='-o StrictHostKeyChecking=no' --private-key ~/.ssh/${local.ssh_filename}.pem ../ansible/playbook.yml -e ansible_sudo_pass=${var.root_pass}"

  }
  depends_on = [time_sleep.wait_30_seconds]
}
