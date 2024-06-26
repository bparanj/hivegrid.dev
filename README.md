# HiveGrid

HiveGrid is a toolchain that simplifies the deployment of Rails 7 applications on AWS by automating the provisioning and configuration of EC2 instances.

Read about the [background](https://www.hivegrid.dev/about/) to learn why this project exists or the entertaining [background story](./sweat.md).

## Purpose

Automate the software delivery process by using a toolchain that leverages Packer, Terraform, Ansible and cloud provider SDKs. The toolchain simplifies infrastructure management tasks by using a declarative language, pre-built templates for common use cases and glue code to integrate with cloud providers.

It targets developers at companies with limited or no DevOps resources. It reduces the time spent on manual infrastructure tasks from days to minutes. Developers can focus more on application development rather than infrastructure complexities. It is designed for those comfortable with the command-line interface, offering customizable templates for each phase of software delivery to streamline processes and enhance efficiency in the software delivery workflow.

## For Whom

HiveGrid is tailored for early-stage startups that are still searching for product/market fit. Scalability is not the immediate concern and modular solution allows startups to iterate quickly based on market feedback.

With this lightweight toochain, you can rapidly build, deploy and experiment with features without the burden of complex architectures. You can validate ideas, make data-driven decisions and adapt your product as you learn more about your target market.

By leveraging the modular approach, you can start small, gradually evolve and prioritize features that resonate with users. Whether you're a small team or a solo founder, HiveGrid is designed to keep your development process lean, agile and focused on rapid experimentation and learning about your target market.

## Modular Toolchain

HiveGrid differs from the competition by offering a modular design that prioritizes simplicity and flexibility. A set of reusable building blocks can be choosen and you can use only what you need for your specific use case. This avoids bloat and keeps your system lean.

It does not impose opinionated choices or predefined architectures. You have the freedom to select the components that fits your requirements. You can avoid over-engineering and unnecessary complexity, especially in the early stages of your startup.

You don't need to start with a complex architecture. Complex systems have steep learning curves and can be overwhelming. With the modular design, you can start with a simple architecture that meets your immediate needs and gradually evolve your architecture organically as your business grows. Beginning with a simpler architecture makes it easier to learn and adapt over time.

The building blocks are designed to be flexible and adaptable, allowing you to build a new system from scratch. The modular components can be combined and customized to create a solution tailored to your needs.

```mermaid
graph TD

subgraph StackA[Ruby Stack A]
    A[deploy_user] --> B[install_ruby]
    B --> C[postgreSQL]
    C --> D[install_caddy]
    
    style StackA fill:#1f3864,stroke:#333,stroke-width:2px,color:#fff
    style C fill:#00758F,stroke:#333,stroke-width:2px,color:#fff
end
```

```mermaid
graph TD

subgraph StackB[Ruby Stack B]
    A[deploy_user] --> B[install_ruby]
    B --> C[MySQL]
    C --> D[install_caddy]
    
    style StackB fill:#1f3864,stroke:#333,stroke-width:2px,color:#fff
    style C fill:#00758F,stroke:#333,stroke-width:2px,color:#fff
end
```

Choose simplicity, flexibility and modularity and stay focused on what matters most — building a successful product.

## Internal Applications

Many companies build web applications for internal use, where scalability is not a concern. In such cases, an EC2 t2.medium instance is sufficient. With HiveGrid, everything can be contained within a single server instance, making it an ideal solution for this scenario.

When building internal web applications, there is typically no need for advanced features like load balancers, zero-downtime deployments, staging environments or other complex setups. HiveGrid provides a simpler approach, allowing companies to focus on developing their application without the overhead of unnecessary infrastructure complexities.

By leveraging HiveGrid, companies can quickly deploy and manage their internal web applications on a single EC2 instance, simplifying the development and deployment process while keeping costs down.

## Project Scope

| Task              | Description                                                                                                 | Tools            |
| ----------------- | ----------------------------------------------------------------------------------------------------------- | ---------------- |
| Install           | Install the software binaries and all dependencies                                                          | Ansible, Packer  |
| Configure         | Configure the software at runtime. TLS certs, firewall settings etc                                         | Ansible          |
| Provision         | Provision the infrastructure. Includes servers, network configuration, IAM permissions                      | Terraform        |


These tools have clear separation of responsibilities, making it easier to extend and customize the functionality according to our needs.

## Tooling

We've knitted together Ansible, Packer, and Terraform to whip up servers on AWS like it's nobody's business. Ansible cuts through the configuration chaos, letting us cherry-pick cloud services, slap on software, and select our web framework with a declarative flair. Packer is our Swiss Army knife, slicing across cloud platforms to provision servers without breaking a sweat. And Terraform? It’s the smart cookie that keeps our code lean and mean, thanks to its idempotent magic. Meshing these tools together, we've streamlined our AWS server setup, keeping our workflow slick, adaptable, and blazing fast.

```mermaid
graph LR
    A[Base Image] --> B[Packer]
    B --> C[Custom Image]
    C --> D[Terraform]
    D --> E[EC2 Instance]
    F[Code Repository] --> G[Capistrano]
    G --> E
    
    B -- Ansible Provisioner --> B

    style B fill:#1f77b4,stroke:#333,stroke-width:2px,color:#fff
    style D fill:#2ca02c,stroke:#333,stroke-width:2px,color:#fff
    style G fill:#ff7f0e,stroke:#333,stroke-width:2px,color:#fff
```

To learn more, read [Toolchain](https://hivegrid.dev/articles/toolchain)

### Advantages of the Toolchain

- Ensures consistent, reliable and reproducible environments
- Automates processes, saving time and reducing human errors
- Enables easy scalability, configuration, and cross-environment deployment
- Facilitates version control, collaboration and rollbacks

## Anti-Features

Does not require:

- Docker
- Load balancer
- Cloudflare
- Traefik

## Requirements

### Development - Control Node

| Name      | Version     |
| --------- | ----------- |
| Python    | 3.12.1      |
| Ansible   | core 2.16.1 |
| Packer    | 1.10.1      |
| Terraform | 1.6.6       |
| Node      | v21.6.2     |
| npm       | 10.5.0      |

## Packer Image

```mermaid
graph LR
    A[Base Image] --> B(Packer)
    B --> C(Ansible)
    C --> D[Custom Image]
    
    style B fill:#1F77B4,stroke:#333,stroke-width:2px,color:#fff
    style C fill:#EE0000,stroke:#333,stroke-width:2px,color:#fff
```

* **Base Image:**  This is your starting point. It is a generic operating system image (e.g., Ubuntu, CentOS).
* **Packer:** This is the tool that automates the process of image creation. You define the desired configuration of your custom image in a Packer template.
* **Ansible:** Packer uses Ansible as a provisioner to configure and customize the base image.
* **Custom Image:** This is the final product produced by Packer. It includes all the modifications you specified, such as:
    * Installed software packages
    * System configurations

Large EC2 instance is used to reduce the time taken to create the image. 

## Rails Stack

The custom AMI created by Packer provides:

| Name         | Version                          | Release Date   |
| ------------ | -------------------------------- | -------------- |
| Ruby         | 3.3.1                            | April 23, 2024 |
| RubyGem      | 3.5.10                           | May 3, 2024    |
| Caddy        | 2.7.6                            | Dec 7, 2023    |
| PostgreSQL   | 16.2 (Ubuntu 16.2-1.pgdg22.04+1) | Feb 8, 2024    |
| Redis        | 7.2.4                            | Jan 9, 2024    |
| Git          | 2.45.0                           | April 29, 2024 |
| Goss         | 0.4.6                            | March 24, 2024 |

See [versions](./VERSIONS.md) for more details.

### Customized Image

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
    
    style B fill:#1F77B4,stroke:#333,stroke-width:2px,color:#fff
```

1. The custom image, which was created using Packer and Ansible, serves as an input to Terraform.
2. Terraform, as an infrastructure as code (IaC) tool, uses the custom image to define and provision the desired infrastructure.
3. Terraform creates an EC2 instance based on the specifications defined in the Terraform configuration files.
4. The EC2 instance is launched using the custom image, ensuring that it includes all the necessary software, configurations, and customizations.

This diagram illustrates the workflow where the custom image, created through the Packer and Ansible, is consumed by Terraform to provision an EC2 instance. Terraform allows you to define the desired state of your infrastructure using declarative configuration files, and it automatically provisions and manages the EC2 instance based on that configuration.

By using a custom image for the EC2 instance, the instance is pre-configured with the required software and settings, minimizing manual setup and configuration after the instance is launched.

The Terraform template defines the following configuration:

- Instance Type: t2.medium
- Region: us-west-2

See [main.tf](./terraform/main.tf) for more details. You can change it in [variables.tf](.terraform/variables.tf).

## Ansible Playbooks

Packer uses Ansible as the provisioner. The Ansible playbooks are included in the master playbook. Packer runs the master playbook to create a custom AMI from a base Ubuntu 22.04 image. The playbooks:

- Install required packages on Ubuntu 22.04
- Implement Intrusion Detection
- Setup deploy user
- Harden SSH Configuration
- Install and Configure Caddy Server
- Install Ruby 3.3.1
- Install PostgreSQL 16
- Install and Setup Redis
- Set server timezone to UTC

See [playbooks](./PLAYBOOKS.md) for more details.

You can:

- Create a new playbook and include it in the master playbook.
- Modify existing playbook included in the master playbook.
- Remove existing playbook from the master playbook.

Ansible Galaxy is only used for database backups. This means we can install the latest version sooner than it takes for the external dependency to update to newer versions.

### Intrusion Detection

From the ansible folder, run the playbook to update the notification email for fail2ban:

```bash
ansible-playbook playbooks/deploy/fail2ban-notification.yml -e "destemail=your-email@your-domain.com"
```

Replace the place holder `your-email@your-domain.com` with your email address. This playbook can be found here: ansible/playbooks/deploy/fail2ban-notification.yml

### Parallel Processing

Parallel processing is enabled in Ansible for speedup. See packer/ansible.cfg for the configuration of Ansible.

### Directory Structure

The ansible folder has directories for deploy and maintain. The playbooks at the ansible folder level are used for creating a custom image. Playbooks that are run for deploying Rails app are inside the deploy folder. The maintain folder is for database backup, CRON job setup or anything that is done as part of maintaining the production server.

You need to provide your IP and PEM file location in ansible/inventory.ini file to use the playbooks inside deploy or maintain folders.

## Testing

The image is tested using Goss. The tests folder contains the tests. Test results are exposed as a JSON endpoint. It can be accessed only within the EC2 instance. SSH into your EC2 instance and run:

```bash
curl http://localhost:8080/healthz | jq .
```

### Goss Test Setup

For adding tests:

- Review the Packer and Terraform template
- Manually `run goss autoadd` on the server
- Copy the generated file on the server to tests/goss.yaml file in the project

## Image and Provisioning Template Catalog

Each stack has its own image and provisioning template, illustrating the separation between the different stacks.

```mermaid
graph LR
  %% Define style for Rails Stack
  style RailsStack fill:#cc0000,stroke:#333,stroke-width:2px
  subgraph RailsStack
    RailsImage[Rails Stack Image] --> RailsTemplate[Rails Provisioning Template]
  end

  %% Define style for Django Stack
  style DjangoStack fill:#092E20,stroke:#333,stroke-width:2px
  subgraph DjangoStack
    DjangoImage[Django Stack Image] --> DjangoTemplate[Django Provisioning Template]
  end
```

## Benefits

1. **Ease of Use**: Simplifies server setup through a few terminal commands.
2. **Automation**: Prevents errors by automating manual tasks and making the process reproducible.
3. **Cost-Effective**: It's free, helping early-stage companies save money.
4. **Basic Security**: Provides basic security features for applications.
5. **Customization**: Allows users to customize their stack by installing preferred software.
6. **Speed**: Offers prebuilt images and tested playbooks to accelerate the process to go live.
7. **Zero Dependency**: Does not require modifications to the application codebase or dependencies.
8. **Technical Support**: Provides quick, personalized support within 24 hours on weekdays.

## Getting Started

### Prerequisites

- An AWS account
- An IAM user with appropriate policies for EC2, S3, and AWS Secrets Manager
- Packer and Terraform installed and configured

SSH Access:

The PEM file used for SSH access to your EC2 instance, is stored in AWS Secrets Manager. This means you can retrieve the PEM file even if you lose the original downloaded copy. You will be charged for storing the PEM file in Secrets Manager. To avoid the cost, you can delete the PEM file from the AWS console after downloading it.

Database Backups:

AWS S3 is used for storing database backups.

### Clone the Project

```bash
git clone git@github.com:bparanj/hivegrid.dev.git
```

### Provision the Server 

From the root of the project, run the Terraform template:

```bash
terraform apply terraform/main.tf
```

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

## Lifecyle Hooks

```mermaid
timeline
    title Software Delivery Lifecycle
    Base Image : Ubuntu
    Custom Hook : Your Code
         : Boto3
         : Playbook
    Custom Image : AMI
    Custom Hook : Your Code
         : Boto3
         : Playbook    
    Provision Instance : EC2 Instance
    Custom Hook : Your Code
         : Boto3
         : Playbook
    Capistrano Deploy : Your App
```

You can customize the process in any of the following phases:

1. Base Image
2. Your Custom Hook
3. Custom Image - Packer Build
4. Your Custom Hook
5. Provision Instance - Terraform Provision
6. Your Custom Hook
7. Capistrano Deploy

Your custom hooks can be cloud-init script, ansible playbook, code written using Ruby, Python, Java or any other SDK for AWS.

## Deploying Rails App

You can use Capistrano to deploy your Rails 7.1 app to the provisioned server. We will be using `dotenv` gem to manage environment variables on the production server.

```mermaid
graph LR
    A[Code] --> B(Capistrano)
    B -- Deploy --> C[EC2 Instance]
    
    style B fill:#1C1B39,stroke:#333,stroke-width:2px,color:#fff
    style C stroke:#333,stroke-width:2px
    
    class C server
```

The EC2 instance, provisioned using Terraform with a custom image, serves as the target environment for the deployed application. Capistrano is used minimally,  mainly because the DSL has a learning curve. If a task can be done in Ansible, it is preferred over Capistrano.

For more details, refer the [sample Rails app](https://github.com/bparanj/capt) with working Capistrano setup.

## Process at a High Level

```mermaid
graph TD
    A[Create IAM dev user] --> B{Default Image Fits Needs?}
    B -->|Yes| C[Use Default Image]
    B -->|No| D[Create Image]
    C --> E[Provision a Server]
    D --> E
    E --> F[Setup DNS Records]
    F --> G[Run SSL playbook]
    G --> H[Run Puma playbook]
    H --> I[Change DB Password]
    I --> J[Change Fail2Ban Email]
    J --> K[Capistrano Deploy]
```

Create Image step is optional. It is only required if the default image does not fit your needs.

## Request Flow

```mermaid
graph LR
    A[Browser] --> B[Caddy]
    B --> C[Puma]
    C --> D[PostgreSQL]
```

Caddy is configured as the reverse proxy to Puma process.

## Getting Started Guide

### Create a AWS Account

[![AWS Account Setup](https://img.youtube.com/vi/qSq6f6fZ_bs/0.jpg)](https://www.youtube.com/watch?v=qSq6f6fZ_bs)

- [Create AWS admin IAM user](https://youtu.be/rLuj3EWRV_4)
- [Create AWS dev IAM user](https://youtu.be/HaIVVql4e8Q)
- [Packer Build Image](https://youtu.be/oIalLv92sqg)
- [Packer Build Image - Part 2](https://youtu.be/me4fX_IhAvw)
- [Packer Public Image](https://youtu.be/uhQse0jWIP8)
- [Terraform Provision](https://youtu.be/lEcJD2DWyMk)
- [Terraform Provision Instance](https://youtu.be/F3R9e4R3I8s)
- [Using Capistrano to Deploy Rails App](https://youtu.be/2bZhikHKTbw)

## License

HiveGrid is released under the [MIT License](https://opensource.org/licenses/MIT).

## Alternatives

- [Zero](https://github.com/commitdev/zero)

## Where to Get Help

Join the [discussions](https://github.com/bparanj/hivegrid.dev/discussions) to get help.

## Contributing

Join the [discussions](https://github.com/bparanj/hivegrid.dev/discussions) to start contributing to this project. Ways to contribute:

- Ansible playbooks for other SQL and NoSQL database servers
- Support other Linux flavors like RHEL, Debian etc.
- Packer and Terraform template for other cloud providers like:

| #    | Provider        | Packer Builder    |
|------|-----------------|-------------------|
| 1    | Microsoft Azure | Azure ARM         |
| 2    | Google Cloud    | Google Compute    |
| 3    | Digital Ocean   | DigitalOcean      |
| 4    | Linode          | Linode            |
| 5    | Rackspace       | OpenStack         |


- Add support for other full stack MVC frameworks like: 

| #    | Framework        | Language     | 
|------|------------------|--------------|
| 1    | Django           | Python       |
| 2    | Laravel          | PHP          |
| 3    | ASP.NET Core MVC | C#           |
| 4    | Spring Boot      | Java         |
| 5    | Phoenix          | Elixir       |
| 6    | Play Framework   | Java/Scala   |


## Endorsements

> Your endorsement with name can go here.

Take it for a spin and if you like it, send me your endorsement.
