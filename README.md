# HiveGrid

## Tasks

You can copy the value of ror_key_secret_name from the output of the terraform apply.

- Set ROR_SECRET_KEY environment variable to "ror_key_secret-b9fa2g7k"
- Run iac/docs/boto/create-iam.md in hive project. Test and provide documentation for the documented steps on hivegrid.dev

## Packer Image

The Packer prebuilt image provides Postgresql, Redis, Caddy and more. See [versions](./VERSIONS.md) for more details.

## Terraform Provisioning

The Terraform template uses the custom AMI created by Packer to provision an EC2 instance with the following configuration:

- Instance Type: c5.4xlarge
- Region: us-west-2
- etc

### Prerequisites

- AWS account
- IAM role with proper policy for EC2, S3 and AWS secrets manager

The PEM file is stored in AWS secrets manager so that you can SSH into your EC2 instance. The only reason it is stored in the secrets manager is that once you download the PEM file, you will not be able to access it again. If you don't want to pay for the AWS secrets, after you download the file, you can delete it from your AWS console.

AWS S3 is used for database backups.

## Ansible Playbooks

Ansible is used as the provisioner in Packer. The playbooks are included in the master playbook. The master playbook is run by Packer to create a custom AMI from a base Ubuntu 22.04 image. The playbooks provide:

- Install required packages on Ubuntu 22.04
- Install and configure Fail2ban
- Setup deploy user
- Harden SSH Configuration
- Install and Configure Caddy Server
- Install Ruby 3.3.0
- Install PostgreSQL 16
- Install and Setup Redis
- Set server timezone to UTC

## Deployment

You can use Capistrano to deploy your Rails 7.1 app to the provisioned server

## Testing

The image is tested using Goss. 

```bash
curl http://localhost:8080/healthz | jq .
```

## Goss Test Setup

- Review the Packer and Terraform template
- Manually run goss autoadd on the server.
- Copy the generated file on the server to tests/goss.yaml file in the project

## Tasks

- Update the steps for different stages: Base Image, Custom Image and Provisioning
- Remove hard-coded AWS Secrets id in javascript/keyDownload.js
- Update goss.yaml by running goss autoadd for all services (after the image creation by Packer stabilizes)
- Update the inventory_file with the public static IP of EC2 instance and the port number where sshd is running

## Toolchain

To learn why these tools are selected for provisioning the server, read [Toolchain](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/toolchain.md)

## Customization

If the image created by Packer does not meet your needs, you can customize the Packer template to change the versions for Ruby, Postgresql, Redis etc.

## Tasks

- Boto3 code to attach a policy to IAM user
- Refer the playbooks and document the high level tasks done for the task description
- Packages Needed : Run a new Rails 7 generator and copy the packages in the Dockerfile
- [Preflight Checklist](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/README.md)
- [Provision Checklist](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/PROVISION.md)
- [AWS CLI on Mac](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/troubleshooting/docs/10.md)
- [Troubleshooting Guide](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/troubleshooting/docs/toc.md)

## Utilities

- [Test SSH Connection](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/deployer/ssh-connection.md)
- [AWS CLI Setup](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/boto-setup.md)
- [Ansible Lint](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/lint.md)

## Concepts

- [Ansible Pipelining](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/pipelining.md)
- [Project Structure](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/project-structure.md)
- [SCP if SSH](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/scp_if_ssh.md)
- [Timzone](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/timezone.md)

