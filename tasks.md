## Tasks

You can copy the value of ror_key_secret_name from the output of the terraform apply.

- Set ROR_SECRET_KEY environment variable to "ror_key_secret-b9fa2g7k"
- Run iac/docs/boto/create-iam.md in hive project. Test and provide documentation for the documented steps on hivegrid.dev
- Check the AWS account using AWS CLI: https://github.com/bparanj/learning-nuxt/blob/c685695c0041a52f9d7380fd5e383f2bb1e0c77b/iac/docs/provisioner/aws-account.md?plain=1
- Flip questions to get high level tasks
- Use fiverr to get feedback
- Update the steps for different stages: Base Image, Custom Image and Provisioning
- Remove hard-coded AWS Secrets id in javascript/keyDownload.js
- Update goss.yaml by running goss autoadd for all services (after the image creation by Packer stabilizes)
- Update the inventory_file with the public static IP of EC2 instance and the port number where sshd is running
- Boto3 code to attach a policy to IAM user
- Refer the playbooks and document the high level tasks done for the task description
- Packages Needed : Run a new Rails 7 generator and copy the packages in the Dockerfile
- [Preflight Checklist](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/README.md)
- [Provision Checklist](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/PROVISION.md)
- [AWS CLI on Mac](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/troubleshooting/docs/10.md)
- [Troubleshooting Guide](https://github.com/bparanj/learning-nuxt/blob/30ad0f16c6cd3c125bcc4a57fa03161730862aa7/iac/prototype/experiments/troubleshooting/docs/toc.md)
