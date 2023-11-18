# Fast deploy VPN Wireguard Server with Terraform, Ansible

## Description

This code deploys small VM in Digital Ocean provider, and setups Wireguard Server
with generating keys and config. It takes ~3 min to deploy WireGuard Server.

## Requrements

- Installed Wireguard on the host OS for generating keys
- Terraform >=1.0.4
- Ansible core >= 2.0
- root access on the host OS

## Tested with Wireguard Client on

- Windows 11
- Keentic Viva/Giga Router
- iOS > 12
- Andorid > 11

## How to

## Using make

1.Init environment

```
make init_env
```

2.Source env_file and enter your DO Token

```
source env_file
```

3.Create terraform workspace

```
make space your_space_name
```

4.Init modules

```
make init
```

5.Plan infrasrtucture with passing arguments **region**, **image**, **size**.
**Attention!** You have to provide local root password.
All ansible output will be hiden because of it, to change this behavior,
change option **sensetive** in variables.tf.

```
make plan region=eu image=rocky size=1
```

6.Deploy infrastructure with passing arguments **region**, **image**, **size**.
Without any confirmations.

```
make apply region=eu image=rocky size=1
```

7.Export private ssh key (name my_ssh.key) [ Optional ]

```
make key
```

8.Destroy infrastructure. Without any confirmations

```
make destroy
```

### Using terraform

1.Clone repo
2.Source env_file
3.Go to directory terraform/
4.Create workspace

```
terraform workspace new  your_space_name
```

5.Init terraform providers

```
terraform init
```

6.Plan your infrastructure
**Attention!** You have to provide local root password.
All ansible output will be hiden because of it, to change this behavior,
change option **sensetive** in variables.tf.

```
 terraform plan -var region=eu -var image=rocky size=1
```

7.Apply configuration

 ```
terraform apply -var region=eu -var image=rocky size=1
 ```

8.Ansible playbook is being started automatically.
**wg_peer.conf** file will be saved in ansible/ directory.
Use this file in your wiregurag client.

## Variables

**region:**

- usa=nyc1 (New York)
- eu=fra1 (Frankfurt)
- ln=lon1 (London)

**image:**

- ubuntu=ubuntu (23-10-x64)
- rocky=rocky (rockylinux-9-x64)

**size:**

- size=1 (1vCPU/1GB Ram)
- size=2 (2vCPU/4GB Ram)

## License

GNU GPL v3
