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

The PEM file is stored in AWS secrets manager so that you can SSH into your EC2 instance.

## Deployment

You can use Capistrano to deploy your Rails 7.1 app to the provisioned server

## Testing

The image is tested using Goss.

## Customization

If the image created by Packer does not meet your needs, you can customize the Packer template to change the versions for Ruby, Postgresql, Redis etc.
