## Versions

### Development - Control Node

| Name      | Version     |
| --------- | ----------- |
| Python    | 3.12.1      |
| Ansible   | core 2.16.1 |
| Packer    | 1.10.1      |
| Terraform | 1.6.6       |
| Node      | v21.6.2     |
| npm       | 10.5.0      |
| AMI       | 0.1.0       |

The AMI image version in main.tf and aws-ubuntu.pkr.hcl must be same. We use the latest custom AMI image with the Terraform.

#### Python

```
python3 --version
Python 3.12.1
```

#### Ansible

```
ansible --version
ansible [core 2.16.1]
  config file = None
  configured module search path = ['/Users/bparanj/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/9.1.0/libexec/lib/python3.12/site-packages/ansible
  ansible collection location = /Users/bparanj/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.12.2 (main, Feb  6 2024, 20:19:44) [Clang 15.0.0 (clang-1500.1.0.2.5)] (/opt/homebrew/Cellar/ansible/9.1.0/libexec/bin/python)
  jinja version = 3.1.3
  libyaml = True
```

### Packer

```
packer version
Packer v1.10.1
```

### Terraform

```
terraform -version
Terraform v1.6.6
on darwin_arm64

Your version of Terraform is out of date! The latest version
is 1.7.4. You can update by downloading from https://www.terraform.io/downloads.html
```

### Production - Target Node

| Name         | Version                                                                                  |
| ------------ | ---------------------------------------------------------------------------------------- |
| ruby-install | 0.9.3                                                                                    |
| Ruby         | 3.3.1                                                                                    |
| Gem          | 2.3.6                                                                                    |
| Goss         | 0.4.6                                                                                    |
| Caddy        | 2.7.6                                                                                    |
| PostgreSQL   | psql (PostgreSQL) 16.2 (Ubuntu 16.2-1.pgdg22.04+1)                                       |
| Redis        | Redis server v=7.2.4 sha=00000000:0 malloc=jemalloc-5.3.0 bits=64 build=4a33ab3ec422ece7 |
| Git          | git version 2.34.1                                                                       |

### Testing

#### Goss

See the playbooks/goss.yml:

```
v0.4.6
```

## Base Image

### Caddy

```
caddy version
v2.7.6 h1:w0NymbG2m9PcvKWsrXO6EEkY9Ru4FJK8uQbYcev1p3A=
```

### Postgresql

```
sudo -u postgres psql
SELECT version();
```

```
PostgreSQL 16.2 (Ubuntu 16.2-1.pgdg22.04+1) on x86_64-pc-linux-gnu, compiled by gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0, 64-bit
```

### Redis

```
redis-server --version
```

```
7.2.4
```
