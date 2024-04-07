# HiveGrid

## Packer Image

The Packer prebuilt image provides:

- Postgresql
- Redis
- Caddy

## Terraform Provisioning

The Terraform template uses the custom AMI created by Packer to provision an EC2 instance with the following configuration:

- Instance Type
- Region
- etc

### Prerequisites

- AWS account
- IAM role with proper policy for EC2, S3 and AWS secrets manager

The PEM file is stored in AWS secrets manager so that you can SSH into your EC2 instance. The only reason it is stored in the secrets manager is that once you download the PEM file, you will not be able to access it again. If you don't want to pay for the AWS secrets, after you download the file, you can delete it from your AWS console.

AWS S3 is used for database backups.

## Ansible Playbooks

Ansible is used as the provisioner in Packer. The playbooks are included in the master playbook. The master playbook is run by Packer to create a custom AMI from a base Ubuntu 22.04 image.

## Deployment

You can use Capistrano to deploy your Rails 7.1 app to the provisioned server

## Testing

The image is tested using Goss.

## Customization

If the image created by Packer does not meet your needs, you can customize the Packer template to change the versions for Ruby, Postgresql, Redis etc.
