# HiveGrid

## Packer Image

The Packer prebuilt image provides:

- Postgresql
- Redis
- Caddy

## Terraform Provisioning

The Terraform templates provisions an EC2 instance with the following configuration:

- Instance Type
- Region
- etc

## Testing

The image is tested using Goss.

## Customization

If the image created by Packer does not meet your needs, you can customize the Packer template to change the versions for Ruby, Postgresql, Redis etc.
