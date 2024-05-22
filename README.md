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

#### Initialize Terraform
In the terminal, navigate to the `terraform-ansible-aws-lab/infra/aws-base` folder and execute the command `terraform init`

Repeat the same step in the `terraform-ansible-aws-lab/infra/dev` folder which contains the module where the infrastructure initialization inputs are located and run the command `terraform init`
    
Go to the path `terraform-ansible-aws-lab/infra/dev`, execute the command `terraform plan` to make sure of what will be implemented. And then the command `terraform apply`


## Application Deployment

#### Ansible hosts file
Add the IP of each EC2 instance to the `terraform-ansible-aws-lab/infra/dev/hosts` file
````
Before: <<APP_IP>> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws-iac-lab

After: 123.123.123.123 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws-iac-lab
````

#### Vars
We will do the same thing for the variables file `terraform-ansible-aws-lab/infra/dev/ansible/vars/vars.yaml`. We'll add the IP of each instance in its proper place

````
Before: todo_app_ip: "<<APP_IP>>"
After: todo_app_ip: "123.123.123.123"
````

#### Database user and password
Still in the `terraform-ansible-aws-lab/infra/dev/ansible/vars/vars.yaml` file, insert a username and password for the MySQL database. Replace the lines of the username and password as shown in the following example:

mysql_user: "~~<<MYSQL_USER>>~~" <br>
mysql_user: "meu_user"


Now go to the path `terraform-ansible-aws-lab/infra/dev/ansible` to start the playbook according to the host file.

    ansible-playbook playbook.yaml -i hosts


## Accessing the application
After the ansible playbook runs and everything is okay. In the terminal, go to the path `terraform-ansible-aws-lab/infra/dev` and run the command `terraform output`, copy the load balancer address and paste it into your browser to access the app

## Removing Infrastructure
Navigate to the `terraform-ansible-aws-lab/infra/dev` folder and execute the command `terraform destroy` to deprovision the infrastructure on AWS and avoid unnecessary costs
