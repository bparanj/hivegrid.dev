In the packer folder, run:

```
export ANSIBLE_CONFIG=$(pwd)/ansible/ansible.cfg
```

## Pre-requisites

- You have created the IAM user with the necessary permissions for EC2, S3 and Secrets Manager.
- You have AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY downloaded from AWS console.
- You have AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables set.
- You have elastic IP address allocated to your EC2 instance.
- DNS A record is setup for the domain name to point to the EC2 instance in your domain registrar's control panel.
- DNS has propagated to the public DNS servers.
- In the Rails app codebase, turn off SSL config in config/environments/production.rb file.

## Custom Image

### Download PEM File

Go to the javascript directory, run:

```
node keyDownload.js
```

If you get error message, delete any offending keys in the known_hosts file:

```
ssh-keygen -R your-ip-address
```

### SSH into the EC2 Instance

On the laptop, create an entry in the ~/.ssh/config file:

```
Host your-domain
    HostName your-ip-address
    User ubuntu
    Port 2222
    IdentityFile /path/to/your/keys/rails-server.pem
```

You can now ssh into the EC2 instance:

```
ssh your-domain
```

### Deploy the Rails App

Define the database user name and password in the config/database.yml:

```yaml
production:
  adapter: postgresql
  encoding: unicode
  database: dox_production
  pool: 5
  username: deploy
  password: password
```

PENDING: Replace the hard coded password with environment variable.

The database user deploy in database.yml file should have the configuration:

```
local   all             deploy                                  md5
```

in /etc/postgresql/16/main/pg_hba.conf.

Generate the master key:

```
cat config/master.key
501f054eecfdeab14e455aecd0b73e9e
```

Define the secret_access key and secret_key_base in the config/credentials.yml.enc file:

```
$ EDITOR="vi" bin/rails credentials:edit
Configured Git diff driver for credentials.
Editing config/credentials.yml.enc...

secret_access_key: devxyztoken321
secret_key_base: 002f6936a50928d429475f2dcb2d9ae87fcdcef0a76be011ac10f48d4101cffababd38ea23343665b86888cbbfde6a86fd5f10466afd69c5570ccf1b0d6d7601
```

Set the SECRET_KEY_BASE environment variable for the deploy user on the EC2 instance.

```
SECRET_KEY_BASE=f6337a26e3d228dc509d9426758e265a0fdc3fc3f750e1a329f63d0e36fc394ff9c8d80c329e87611d701d429e45513c4a1548b24bcdcbc31606ddbc8ddc44ab
```

From the Rails project root, run the Ansible deploy playbook with the following command:

```
ansible-playbook -i inventory.ini deploy.yml --extra-vars "rails_master_key=501f054eecfdeab14e455aecd0b73e9e"
```

The value of rails_master_key is the same as the config/master.key file.

### Rails Puma Setup

Go to the directory: /path/to/hivegrid.dev/ansible/playbooks, run:

```
ansible-playbook -i inventory_file rails_app.yml
```

### Caddy SSL Setup

Customize the inventory_file to provide the public static IP of EC2 instance and the port number where sshd is running. It should look like:

```
[webserver]
your-ip-address ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/path/to/your/keys/rails-server.pem ansible_ssh_port=2222
```

Go to the directory: /path/to/hivegrid.dev/ansible/playbooks, run:

```
ansible-playbook -i inventory_file caddy_ssl.yml
```
