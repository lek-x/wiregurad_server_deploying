# Fast deploy VPN Wireguard Server with Terraform, Ansible**

## Description

This code deploys small VM in Digital Ocean provider, and setups Wireguard Server
with generating keys and config. It takes ~5 min to deploy WireGuard Server.

## Requrements

- Installed Wireguard on the host OS for generating keys
- Terraform >=1.0.4
- Ansible core >= 2.0

## Tested with Wireguard Client on

- Windows 11
- Keentic Viva/Giga Router
- iOS > 12
- Andorid > 11

## How to

## Using make

1.Init modules

```
make init
```

2.Plan infrasrtucture with passing arguments **reg**, **img**

```
make plan reg=eu img=rocky
```

3.Deploy infrastructure with passing arguments **reg**, **img**. Without any confirmations

```
make apply reg=eu img=rocky
```

4.Export private ssh key (name my_ssh.key)

```
make key
```

5.Destroy infrastructure. Without any confirmations

```
make destroy
```

### Using terraform

1.Clone repo
2.Add your Digital Ocean token to **terraform.tfvars.example**,
  and rename it to **terraform.tfvars**
3.Init terraform providers

  ```
 terraform init
  ```

1.Plan your infrastructure

  ```
   terraform plan -var region=eu -var image=rocky
  ```

1.Apply configuration

  ```
 terraform apply -var region=eu -var image=rocky
  ```

1.Ansible playbook runs automatically, **wg_peer.conf** file will be saved
in current directory. Use this file in your wiregurag client.

## Variables

region: usa=nyc1 (New York), eu=fra1 (Frankfurt), ln=lon1 (London)
image: ubuntu=ubuntu-22-10-x64, rocky=rockylinux-9-x64

## License

GNU GPL v3
