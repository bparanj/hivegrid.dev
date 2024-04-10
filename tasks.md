## Tasks

You can copy the value of ror_key_secret_name from the output of the terraform apply.

- Set ROR_SECRET_KEY environment variable to "ror_key_secret-b9fa2g7k"
- Run iac/docs/boto/create-iam.md in hive project. Test and provide documentation for the documented steps on hivegrid.dev
- Flip questions to get high level tasks
- Update the steps for different stages: Base Image, Custom Image and Provisioning
- Remove hard-coded AWS Secrets id in javascript/keyDownload.js
- Update goss.yaml by running goss autoadd for all services (after the image creation by Packer stabilizes)
- Update the inventory_file with the public static IP of EC2 instance and the port number where sshd is running
- Refer the playbooks and document the high level tasks done for the task description
- [Preflight Checklist](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/README.md)
- [Provision Checklist](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/PROVISION.md)
- [Troubleshooting Guide](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/troubleshooting/docs/toc.md)
- Create a campaign for hexdev and post on the forum for contribution
- Create a campaign for freecodecamp and contact them for contribution
- Use fiverr to get feedback

## Storyboard

### Account Setup

- Backup the lead generation course on AWS and Google drive to free up space.
- Signup for AWS account using new email 
- Create a IAM user called awsdev with full administrator privilege
- Download the awsdev AWS credentials from AWS console
- Install AWS CLI
- [AWS CLI on Mac](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/troubleshooting/docs/10.md)
- Run aws caller identity
- [AWS CLI Setup](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/boto-setup.md)
- Check the AWS account using AWS CLI: https://github.com/bparanj/learning-nuxt/blob/c685695c0041a52f9d7380fd5e383f2bb1e0c77b/iac/docs/provisioner/aws-account.md?plain=1
- Setup development environment for boto3.
- Use the awsdev credentials and run the boto3 program to create IAM user called deploy. Boto3 code to attach a policy to IAM user: https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/boto/create-iam.md
- Download the AWS credentials from AWS console for deploy user.

### Provision Server

- Setup the AWS credential environment variables for deploy user
- Run the terraform template
- Use keyDownload.js to download the PEM file
- SSH into EC2 instance using the PEM file
- Verify

### Development Workflow

- Using Packer
- Using Ansible
- Using Terraform
- Testing using Goss
- Documenting and Troubleshooting Guide

## Utilities

- [Test SSH Connection](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/deployer/ssh-connection.md)
- [AWS CLI Setup](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/boto-setup.md)
- [Ansible Lint](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/ansible/lint.md)

## Concepts

- [Ansible Pipelining](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/pipelining.md)
- [Project Structure](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/project-structure.md)
- [SCP if SSH](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/scp_if_ssh.md)
- [Timezone](https://github.com/bparanj/learning-nuxt/blob/main/iac/docs/basics/timezone.md)
