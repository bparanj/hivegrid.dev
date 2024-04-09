# Ansible Playbooks

## Deploy User

- Create deploy user
- Ensure deploy user has passwordless sudo
- Set file permissions for the sudoers file for deploy

## Fail2ban

- Install and configure Fail2ban
- Ensure Fail2ban is running and enabled on boot

In fail2ban/files/jail.local, change the destemail:

<Email for sending ban notifications>
destemail = your-email@your-domain.com

## Harden SSH

- Harden SSH Configuration for Base Image
- Prevent root login via SSH
- Disable password authentication
- Change default SSH port
- Restart SSH service to apply changes

## Caddy Server

- Install and Configure Caddy Server
- Create Caddyfile for reverse proxy

## Ruby

- Install Ruby using ruby-install from source
- Verify Ruby installation
- Turn off rdoc installation for gem installation
- Update RubyGems to the latest version

## Packages

- Install development tools and libraries
- Ensure the locale is set to en_US.UTF-8

## Install PostgreSQL 16

- Install prerequisite packages
- Ensure PostgreSQL is running and enabled on boot
- Configure PostgreSQL to listen on localhost only
- Restrict connections to local machine
- Create database user with a password and grant CREATE DB privilege
- Add deploy user md5 auth to pg_hba.conf

## Redis

- Install build dependencies for Redis
- Ensure Redis user exists
- Create Redis systemd service file
- Reload systemd to apply new service file and restart Redis service
- Ensure Redis service is enabled and started
- Disable specific Redis commands

## Timezone

- Set server timezone to UTC