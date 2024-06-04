## Project overview
The purpose of this lab is practice the knowledge of Ansible, Terraform and AWS and understand how these tools relate

## Main goal
To get skills in Infrastructure as Code (IaC) and deploy an application on AWS using EC2

## Requirements and Tools

We'll use Ubuntu Linux for this lab. Some commands/details may vary depending on the operating system used

1. [Terraform](https://developer.hashicorp.com/terraform/install)
2. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
3. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Lab Architecture
- An Ubuntu EC2 instance that will be used to run the todo-app on Node.js
- An Ubuntu EC2 instance that will be MySQL database
- Both machines will be managed by Ansible
- Load balancer that receives requests and redirects them to the application instance


## Create SSH key to access EC2 instances
First, we need to prepare the necessary configurations to run the environment. In addition to having the above tools previously installed, we should create an SSH key that will be used to access the EC2 instances and manage them via Ansible. The example below, we'll create one called `aws-iac-lab` which is being saved in the `~/.ssh` folder

    ssh-keygen -f ~/.ssh/aws-iac-lab -t rsa

Enter a password for the key or leave it blank


## AWS CLI Login
In the AWS console, go to `IAM`, create a new user, give it administrative permission, and then create an `Access key` allowing access to the `CLI`... Save that credentials, as we will use them shortly. In the terminal, execute the following command and enter the access key information

    aws configure

## Infrastructure Deployment
#### Clone repository

    git clone git@github.com:pcalves1/terraform-ansible-aws-lab.git

#### Database user and password
Inside path `terraform-ansible-aws-lab/infra/dev`, create a new file named `secrets.tf` in order to handle the authentication for the database. This file will be only accessible locally and it must not be exposed on Github. Follow the example below, change the default value for your mysql user and password

```
variable "mysql_user" {
  default = "my_user"
  type = string
  sensitive = true
}

variable "mysql_password" {
  default = "my_password"
  type = string
  sensitive = true
}
```

#### Initialize Terraform
In the terminal, navigate to the `terraform-ansible-aws-lab/infra/aws-base` folder and execute the command `terraform init`

Repeat the same step in the `terraform-ansible-aws-lab/infra/dev` folder which contains the module where the infrastructure initialization inputs are located and run the command `terraform init`
    
Go to the path `terraform-ansible-aws-lab/infra/dev`, execute the command `terraform plan` to make sure of what will be implemented. And then the command `terraform apply`


## Accessing the application
When command `terraform apply` is finished, both machines in background will run ansible playbook to configure application and database... It will take a considerable amount of time. Then you'll be able to access the application copying loadbalance address on terraform output and paste to your browser

## Removing Infrastructure
Navigate to the `terraform-ansible-aws-lab/infra/dev` folder and execute the command `terraform destroy` to deprovision the infrastructure on AWS and avoid unnecessary costs
