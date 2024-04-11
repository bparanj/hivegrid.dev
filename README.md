# HiveGrid

A toolchain to provision an EC2 instance to run your Rails 7 apps on AWS. Read about the [background](https://www.hivegrid.dev/about/) to learn why this project exists.

### Project Scope

| Task              | Description                                                                                                 | Tools            |
| ----------------- | ----------------------------------------------------------------------------------------------------------- | ---------------- |
| Install           | Install the software binaries and all dependencies                                                          | Ansible, Packer  |
| Configure         | Configure the software at runtime. TLS certs, firewall settings etc                                         | Ansible          |
| Provision         | Provision the infrastructure. Includes servers, network configuration, IAM permissions                      | Terraform        |

## Choice of Tools

This project leverages the strengths of Ansible, Packer, and Terraform to provision a server on AWS. Ansible's declarative style programming provide flexibility in terms of cloud service choices, software installation and web framework selection. Packer's provider plugins offer flexibility to provision servers on various cloud platforms. Terraform's idempotent nature simplifies the provisioning process with minimal code. We combine these tools and streamline server provisioning on AWS while maintaining adaptability and efficiency.

To learn more, read [Toolchain](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/toolchain.md)

### Advantages of the Toolchain

- Ensures consistent, reliable, and reproducible environments
- Automates processes, saving time and reducing human errors
- Enables easy scalability, configuration, and cross-environment deployment
- Facilitates version control, collaboration, and rollbacks

## Packer Image

```mermaid
graph LR
    A[Base Image] --> B(Packer)
    B --> C(Ansible)
    C --> D[Custom Image]
```

* **Base Image:**  This is your starting point. It is a generic operating system image (e.g., Ubuntu, CentOS).
* **Packer:** This is the tool that automates the process of image creation. You define the desired configuration of your custom image in a Packer template.
* **Ansible:** Packer uses Ansible as a provisioner to configure and customize the base image.
* **Custom Image:** This is the final product produced by Packer. It includes all the modifications you specified, such as:
    * Installed software packages
    * System configurations

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

The custom image created in the previous step is the input to Terraform and the output is a running EC2 instance:

```mermaid
graph LR
    A[Custom Image] --> B(Terraform)
    B --> C[EC2 Instance]
```

1. The custom image, which was created using Packer and Ansible, serves as an input to Terraform.
2. Terraform, as an infrastructure as code (IaC) tool, uses the custom image to define and provision the desired infrastructure.
3. Terraform creates an EC2 instance based on the specifications defined in the Terraform configuration files.
4. The EC2 instance is launched using the custom image, ensuring that it includes all the necessary software, configurations, and customizations.

This diagram illustrates the workflow where the custom image, created through the Packer and Ansible, is consumed by Terraform to provision an EC2 instance. Terraform allows you to define the desired state of your infrastructure using declarative configuration files, and it automatically provisions and manages the EC2 instance based on that configuration.

By using a custom image for the EC2 instance, we ensure that the instance is pre-configured with the required software and settings, reducing manual setup and configuration after the instance is launched.

The Terraform template defines the following configuration:

- Instance Type: t2.medium
- Region: us-west-2

See [main.tf](./terraform/main.tf) for more details. You can change it in terraform/variables.tf.

## Getting Started

### Prerequisites

- AWS account
- IAM role with appropriate policy for EC2, S3 and AWS secrets manager

The PEM file is stored in AWS secrets manager so that you can SSH into your EC2 instance. The only reason it is stored in the secrets manager is that once you download the PEM file, you will not be able to access it again. If you don't want to pay for the AWS secrets, after you download the file, you can delete it from your AWS console.

AWS S3 is used for database backups.

### Download PEM File

To install dependencies, go to javascript folder directory and run:

```
npm install
```

You must set the environment variables to proper values:

```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
ROR_SECRET_KEY
```

You will see the value for ROR_SECRET_KEY from the output of the `terraform apply` command.

To download the PEM file, run:

```bash
node keyDownload.js
```

### Steps

Clone this project. From the root of the project, run the Terraform template:

```bash
terraform apply terraform/main.tf
```

## Where to Get Help

Join the [discussions](https://github.com/bparanj/hivegrid.dev/discussions) to get help.

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

```mermaid
graph LR
    A[Code] --> B(Capistrano)
    B -- Deploy --> C[EC2 Instance]
```

The EC2 instance provisioned using Terraform and the custom image, serves as the target environment for the deployed application.

## Testing

The image is tested using Goss. The tests folder contains the tests. SSH into your EC2 instance and run:

```bash
curl http://localhost:8080/healthz | jq .
```

### Goss Test Setup

For adding tests:

- Review the Packer and Terraform template
- Manually `run goss autoadd` on the server
- Copy the generated file on the server to tests/goss.yaml file in the project

## Contributing

Join the [discussions](https://github.com/bparanj/hivegrid.dev/discussions) to start contributing to this project. Ways to contribute:

- Ansible playbooks for other SQL and NoSQL database servers
- Support other Linux flavors like RHEL, Debian etc.
- Packer and Terraform template for other cloud providers like Digital Ocean, Google Cloud etc
- Add support for other full stack MVC frameworks like Symfony, Django, Laravel, Spring Boot, Yesod, CakePHP, Phoenix, CodeIgniter etc

## License

HiveGrid is released under the [MIT License](https://opensource.org/licenses/MIT).
