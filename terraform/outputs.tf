# Show me public ip
output "public_ip_server" {
  value = digitalocean_droplet.VM1.ipv4_address
}

output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
