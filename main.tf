#### Describe provider
provider "digitalocean" {
  token = var.do_token
}

#### Import my own SSH key
resource "digitalocean_ssh_key" "default" {
  name       = "My_key"
  public_key = file(var.ssh_pub_key)
}


### Create new VM
resource "digitalocean_droplet" "VM1" {
  image  = "ubuntu-21-10-x64"
  name   = "wg"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
  tags = ["wg"]
}


resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      ip_name = digitalocean_droplet.VM1.ipv4_address
    }
  )
  filename = "${path.module}/ansible/inventory"
  depends_on = [digitalocean_droplet.VM1]
}

# Show me public ip
 output "public_ip_server" {
  value = digitalocean_droplet.VM1.ipv4_address
}



