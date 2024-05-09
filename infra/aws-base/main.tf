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
  security_groups             = [aws_security_group.eks_general_access.id]
  subnet_id                   = aws_subnet.eks_subnet.id
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.ssh_key
  user_data = <<-EOF
            #!/bin/bash
            echo 'export MYSQL_HOST="dev-mysql"' >> /etc/profile;
            echo 'export MYSQL_ROOT_PASSWORD="qwe@123"' >> /etc/profile;
            echo 'export MYSQL_DATABASE="todo_items"' >> /etc/profile;
            echo 'export MYSQL_USER="pcalves"' >> /etc/profile;
            EOF

  tags = {
    Name : var.instance_names_dev[count.index]
    lab = "eks"
  }
  depends_on = [aws_internet_gateway.eks_lab_gw]
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