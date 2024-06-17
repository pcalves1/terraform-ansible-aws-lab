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

resource "aws_key_pair" "ssh_key" {
  key_name   = var.ssh_key
  public_key = file("~/.ssh/${var.ssh_key}.pub")
}


output "load_balancers_address" {
  value = {
    application = aws_lb.elb_todo_app.dns_name,
  }
}
