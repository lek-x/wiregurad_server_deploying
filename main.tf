#### Describe provider
provider "digitalocean" {
  token = var.do_token
}

### Import SSH key or Use existing key in DO
#resource "digitalocean_ssh_key" "default" {
#  name       = "My_key"
#  public_key = file(var.ssh_pub_key)
#  depends_on=[data.digitalocean_ssh_key.default]
#}

## or Use existing key in DO
data "digitalocean_ssh_key" "default" {
  name = "My_key"

}

### Create new VM
resource "digitalocean_droplet" "VM1" {
  image    = var.dorplet_ver
  name     = "wg"
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.default.id] #or [digitalocean_ssh_key.default.fingerprint])
  tags     = ["wg"]

}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      ip_name = digitalocean_droplet.VM1.ipv4_address
    }
  )
  filename   = "${path.module}/ansible/inventory"
  depends_on = [digitalocean_droplet.VM1]
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [local_file.inventory]

  create_duration = "60s"
}
resource "null_resource" "playbook" {
  provisioner "local-exec" {
    command = "ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook -u root -i ansible/inventory --ssh-common-args='-o StrictHostKeyChecking=no' --private-key ${var.ssh_private_key} ansible/wg_up.yml"

  }
  depends_on = [time_sleep.wait_60_seconds]
}

# Show me public ip
output "public_ip_server" {
  value = digitalocean_droplet.VM1.ipv4_address
}
