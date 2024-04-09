# HiveGrid

Why does this project exist? Read [about](https://www.hivegrid.dev/about/).

### Project Scope

| Task              | Description                                                                                                                               | Tools            |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------- |
| Install           | Install the software binaries and all dependencies.                                                                                       | Ansible, Packer  |
| Configure         | Configure the software at runtime. Includes port settings, TLS certs, service discovery, leaders, followers, replication, etc.            | Ansible          |
| Provision         | Provision the infrastructure. Includes servers, load balancers, network configuration, firewall settings, IAM permissions, etc.           | Terraform        |

To learn why these tools are selected for provisioning the server, read [Toolchain](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/toolchain.md)

## Packer Image

The custom AMI created by Packer provides:

| Name         | Version                                                                                  |
| ------------ | ---------------------------------------------------------------------------------------- |
| Ruby         | 3.3.0                                                                                    |
| RubyGem      | 2.3.6                                                                                    |
| Caddy        | 2.7.6                                                                                    |
| PostgreSQL   | psql (PostgreSQL) 16.2 (Ubuntu 16.2-1.pgdg22.04+1)                                       |
| Redis        | Redis server v=7.2.4 sha=00000000:0 malloc=jemalloc-5.3.0 bits=64 build=4a33ab3ec422ece7 |
| Git          | git version 2.34.1                                                                       |
| Goss         | 0.4.4                                                                                    |

See [versions](./VERSIONS.md) for more details.

### Customization

If the image created by Packer does not meet your needs, you can customize the Packer template in packer/aws-ubuntu.pkr.hck to change the base image and change what is included in the master playbook in ansible/playbooks/master_playbook.yml. For instance, you can create a new playbook for MySQL and replace the Postgres playbook. You can change the versions for Ruby, Postgresql, Redis etc in the existing playbooks in ansible/playbooks folder.

## Terraform Provisioning

The Terraform template uses the custom AMI created by Packer to provision an EC2 instance with the following configuration:

- Instance Type: t2.medium
- Region: us-west-2

See [main.tf](./terraform/main.tf) for more details. You can change it in terraform/variables.tf.

### Prerequisites

- AWS account
- IAM role with appropriate policy for EC2, S3 and AWS secrets manager

The PEM file is stored in AWS secrets manager so that you can SSH into your EC2 instance. The only reason it is stored in the secrets manager is that once you download the PEM file, you will not be able to access it again. If you don't want to pay for the AWS secrets, after you download the file, you can delete it from your AWS console.

AWS S3 is used for database backups.

## Ansible Playbooks

Ansible is used as the provisioner in Packer. The playbooks are included in the master playbook. The master playbook is run by Packer to create a custom AMI from a base Ubuntu 22.04 image. The playbooks:

- Install required packages on Ubuntu 22.04
- Install and configure Fail2ban
- Setup deploy user
- Harden SSH Configuration
- Install and Configure Caddy Server
- Install Ruby 3.3.0
- Install PostgreSQL 16
- Install and Setup Redis
- Set server timezone to UTC

See [playbooks](./PLAYBOOKS.md) for more details.

## Deploying Rails App

You can use Capistrano to deploy your Rails 7.1 app to the provisioned server.

## Testing

The image is tested using Goss. The tests folder contains the tests.

```bash
curl http://localhost:8080/healthz | jq .
```

### Goss Test Setup

For adding tests:

- Review the Packer and Terraform template
- Manually `run goss autoadd` on the server
- Copy the generated file on the server to tests/goss.yaml file in the project

## Utilities

- [Test SSH Connection](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/deployer/ssh-connection.md)
- [AWS CLI Setup](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/boto-setup.md)
- [Ansible Lint](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/lint.md)

## Concepts

- [Ansible Pipelining](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/pipelining.md)
- [Project Structure](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/project-structure.md)
- [SCP if SSH](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/scp_if_ssh.md)
- [Timezone](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/timezone.md)
