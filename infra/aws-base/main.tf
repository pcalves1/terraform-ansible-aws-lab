terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "todo_app_instance" {
  ami                         = var.ami
  count                       = length(var.instance_names_dev)
  instance_type               = var.instance
  security_groups             = [aws_security_group.app_general_access.id]
  subnet_id                   = aws_subnet.lab_subnet_a.id
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.ssh_key

  tags = {
    Name = var.instance_names_dev[count.index]
  }
  depends_on = [aws_internet_gateway.terraform_ansible_lab_gw]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key
  public_key = file("~/.ssh/${var.ssh_key}.pub")
}

output "aws-dev-app-ips" {
  value = {
    for idx, instance_name in var.instance_names_dev : "${instance_name}" => aws_instance.todo_app_instance[idx].public_ip
  }
}
