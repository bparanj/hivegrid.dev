variables {
  aws_region      = "us-west-2"
  instance_type   = "c5.4xlarge"
  source_ami_name = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
  ami_owners      = ["099720109477"]
  ssh_username    = "ubuntu"
  playbook_file   = "../ansible/playbooks/master_playbook.yml"
  ansible_user    = "ubuntu"
}

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      version = "~> 1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  communicator  = "ssh"
  ami_name      = "packer-ubuntu-aws-${regex_replace(timestamp(), "[^a-zA-Z0-9-]", "")}"
  instance_type = "${var.instance_type}"
  region        = "${var.aws_region}"
  source_ami_filter {
    filters = {
      name                = "${var.source_ami_name}"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = var.ami_owners
  }
  ssh_username = "${var.ssh_username}"
  ami_groups   = ["all"]
  tags = {
    "Name"        = "UbuntuImage"
    "Environment" = "Production"
    "OS_Version"  = "Ubuntu 22.04"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
    "Version"     = "0.0.7"
  }
}

build {
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    playbook_file = "${var.playbook_file}"
    user          = "${var.ansible_user}"
    use_proxy     = false
    ansible_env_vars = [
      "ANSIBLE_HOST_KEY_CHECKING=False"
    ]
  }

  post-processor "manifest" {
    output = "manifest.json"
  }
}
