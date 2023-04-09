# Fast deploy VPN Wireguard Server with Terraform, Ansible

## Description

This code  deploys VM(droplet) in Digital Ocean provider, and setups Wireguard Server. It takes 10 min to deploy WireGuard Server


## Requrements:
  - Installed Wireguard on the host OS
  - Terraform >=1.0.4
  - Ansible core >= 2.0


## Tested with:
  - Wireguard Client Windows 11
  - Keentic Viva Router


# How to
### Deploy VM with terraform
1. Clone repo
2. Add your Digital Ocean token to **terraform.tfvars.example**, amd rename it to **terraform.tfvars**
3. Init terraform providers
  ```
 terraform init
  ```
4. Check config
  ```
   terraform validate
  ```
5. Apply configuration
  ```
 terraform apply
  ```
6. Ansible playbook runs automatically,  **wg_peer.conf** file will be saved in current directory. Use file in your wiregurag client




## License
GNU GPL v3
