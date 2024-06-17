variable "aws_region" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "instance" {
  type = string
}

variable "associate_public_ip" {
  type = string
}

variable "ami" {
  type = string
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}


variable "vpc_tags" {
  default = {
    Name = "terraform-ansible-aws-lab"
  }
}

variable "subnet_tags" {
  default = {
    Name = "terraform-ansible-aws-lab"
  }
}

variable "subnet_cidr_block_a" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_block_b" {
  default = "10.0.2.0/24"
}

variable "mysql_user" {
  type      = string
  sensitive = true
}

variable "mysql_password" {
  type      = string
  sensitive = true
}
