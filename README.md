# HiveGrid

A toolchain to provision an EC2 instance to run your Rails 7 apps on AWS. Read about the [background](https://www.hivegrid.dev/about/) to learn why this project exists. If you want to read the entertaining version, read the [background story](./sweat.md).

### Project Scope

| Task              | Description                                                                                                 | Tools            |
| ----------------- | ----------------------------------------------------------------------------------------------------------- | ---------------- |
| Install           | Install the software binaries and all dependencies                                                          | Ansible, Packer  |
| Configure         | Configure the software at runtime. TLS certs, firewall settings etc                                         | Ansible          |
| Provision         | Provision the infrastructure. Includes servers, network configuration, IAM permissions                      | Terraform        |


These tools have clear separation of responsibilities, making it easier to extend and customize the functionality according to our needs.

## Choice of Tools

We've knitted together Ansible, Packer, and Terraform to whip up servers on AWS like it's nobody's business. Ansible cuts through the configuration chaos, letting us cherry-pick cloud services, slap on software, and select our web framework with a declarative flair. Packer is our Swiss Army knife, slicing across cloud platforms to provision servers without breaking a sweat. And Terraform? It’s the smart cookie that keeps our code lean and mean, thanks to its idempotent magic. Meshing these tools together, we've streamlined our AWS server setup, keeping our workflow slick, adaptable, and blazing fast.

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

If the image created by Packer does not meet your requirements, you can:

1. Customize the Packer template:
   - Open the file `packer/aws-ubuntu.pkr.hcl`
   - Modify the base image and other configurations as needed

2. Modify the master playbook:
   - Open the file `ansible/playbooks/master_playbook.yml`
   - Change the included playbooks to suit your needs
     - For example, you can create a new playbook for MySQL and replace the Postgres playbook

3. Customize versions in existing playbooks:
   - Go to the `ansible/playbooks` folder
   - Modify the versions for Ruby, Postgresql, Redis, etc. in the corresponding playbooks

By following these steps, you can tailor the Packer-generated image to your specific requirements.

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

- An AWS account
- An IAM role with appropriate policies for EC2, S3, and AWS Secrets Manager

SSH Access:

The PEM file used for SSH access to your EC2 instance, is stored in AWS Secrets Manager. This means you can retrieve the PEM file even if you lose the original downloaded copy. You will be charged for storing the PEM file in Secrets Manager. To avoid the cost, you can delete the PEM file from the AWS console after downloading it.

Database Backups:
AWS S3 is used for storing database backups.

### Download PEM File

You must have nodejs installed on your laptop. To install dependencies, go to javascript folder directory and run:

```
npm install
```

Set the following environment variables to proper values:

```bash
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
ROR_SECRET_KEY
```

You will see the value for `ROR_SECRET_KEY` from the output of the `terraform apply` command.

To download the PEM file, run:

```bash
node keyDownload.js
```

### Steps

Clone this project. 

```bash
git clone git@github.com:bparanj/hivegrid.dev.git
```

From the root of the project, run the Terraform template:

```bash
terraform apply terraform/main.tf
```

## Where to Get Help

Join the [discussions](https://github.com/bparanj/hivegrid.dev/discussions) to get help.

## Ansible Playbooks

Packer uses Ansible as the provisioner. The Ansible playbooks are included in the master playbook. Packer runs the master playbook to create a custom AMI from a base Ubuntu 22.04 image. The playbooks:

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
- Packer and Terraform template for other cloud providers like:

| #    | Provider        |
|------|-----------------|
| 1    | Amazon AWS      |
| 2    | Microsoft Azure |
| 3    | Google Cloud    |
| 4    | Digital Ocean   |
| 5    | Linode          |

- Add support for other full stack MVC frameworks like: 

| #    | Framework        | Language     | 
|------|------------------|--------------|
| 1    | Ruby on Rails    | Ruby         |
| 2    | Django           | Python       |
| 3    | Laravel          | PHP          |
| 4    | ASP.NET Core MVC | C#           |
| 5    | Spring Boot      | Java         |
| 6    | Phoenix          | Elixir       |
| 7    | Play Framework   | Java/Scala   | 

## License

HiveGrid is released under the [MIT License](https://opensource.org/licenses/MIT).
