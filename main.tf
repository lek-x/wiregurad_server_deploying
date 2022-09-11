#### Describe provider
provider "digitalocean" {
  token = var.do_token
}

#### Import my own SSH key
#resource "digitalocean_ssh_key" "default" {
#  name       = "My_key"
#  public_key = file(var.ssh_pub_key)
#}

data "digitalocean_ssh_key" "default" {
  name = "My_key"
}


### Create new VM
resource "digitalocean_droplet" "VM1" {
  image    = "ubuntu-22-04-x64"
  name     = "wg"
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.default.id] #[digitalocean_ssh_key.default.fingerprint]
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
    command = "ansible-playbook -u root -i ansible/inventory --ssh-common-args='-o StrictHostKeyChecking=no' --private-key ~/.ssh/storemez ansible/wg_up.yml -v"

  }
  depends_on = [time_sleep.wait_60_seconds]
}


# Show me public ip
output "public_ip_server" {
  value = digitalocean_droplet.VM1.ipv4_address
}



