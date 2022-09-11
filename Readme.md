# Fast deploy VPN Wireguard Server with Terraform, Ansible

## Description

This code  deploys VM(droplet) in Digital Ocean provider, and setups Wireguard Server. It takes 10 min to deploy WireGuard Server


## Requrements:
  - Linux OS host
  - Installed Wireguard on the host OS
  - Terraform >=1.0.4
  - Ansible core >= 2.0
  - SSH keys


## Tested with:
  - Wireguard Client Windows 11
  - Keentic Viva Router


# How to
### Deploy VM with terraform 
1. Clone repo
2. Add your Digital Ocean token to terraform.tfvars.example, amd rename it to terraform.tfvars
2. Init terraform providers
  ```
 terraform init
  ```
3. Edit main.tf, uncomment block if you want to upload new ssh key and comment another block.
 ```
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

 ```
4. Terraform will ask you about path of ssh private and public keys, but you cand edit variables.tf to hardcode it. Pay attention ssh private key paths is using to run ansible playbook.
4. Check config
  ```
 terraform validate
  ```
5. If config is OK, then Deploy VM
```
terraform apply
```
If all is ok, VM will be created, and in ansible/ directory will be inventory file.

6. Ansible playbook runs automatically



## License
GNU GPL v3
