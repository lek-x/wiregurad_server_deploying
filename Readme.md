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
### Stage 1. Deploy VM with terraform 
1. Clone repo
2. Add your Digital Ocean token to terraform.tfvars.example, amd rename it to terraform.tfvars
2. Init terraform providers
  ```
 terraform init
  ```
3. Copy your SSH pub key into root of directory
4. Edit variable ssh_pub_key (in variables.tf) according to name of your pub key
4. Check config
  ```
 terraform validate
  ```
5. If config is OK, then Deploy VM
```
terraform apply
```
If all is ok, VM will be created, and in ansible/ directory will be inventory file.

### Stage 2. Setup WireGuard

1. Go to ansible/ directory
2. You cand define your settings for WireGuard in ansible/roles/wg_install/defaults/main.yml
4. Run command (don't forget to write your private-key name)

```
 ansible-playbook wg_up.yml  --private-key ~/.ssh/your_private_key  
```
5. If all is OK you will get wg_peer.conf in ansible/dir
6. Use this config file in any wireguard client


## License
GNU GPL v3