variable "aws_region" {
  type = string
}

variable "ssh_key" {
  type = string
}

variable "instance" {
  type = string
}

variable "app_security_group_name" {
  type = string
}

variable "elb_security_group_name" {
  type = string
}


variable "vpc_name" {
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

variable "instance_names_dev" {
  type    = list(string)
  default = ["dev-app", "dev-mysql"]
}

variable "availability_zone_a" {
  type = string
}

variable "availability_zone_b" {
  type = string
}

variable "subnet_cidr_block_a" {
  default = "10.0.0.0/25"
}

variable "subnet_cidr_block_b" {
  default = "10.0.128.0/25"
}


# tenho que ter duas subnets com duas AZ diferentes para criar o ELB