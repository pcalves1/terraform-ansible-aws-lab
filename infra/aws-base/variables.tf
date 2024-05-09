variable "aws_region" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "instance" {
  type = string
}

variable "security_group_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "associate_public_ip" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "ami" {
  type = string
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.0.1.0/24"
}

variable "vpc_tags" {
  default = {
    Name = "eks_vpc"
    lab  = "eks"
  }
}

variable "subnet_tags" {
  default = {
    Name = "eks_lab"
    lab  = "eks"
  }
}

variable "instance_names_dev" {
  type    = list(string)
  default = ["dev-app", "dev-mysql"]
}
