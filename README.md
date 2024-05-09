## Project overview
O propósito desse laboratório é por em prática os conhecimentos de Ansible, Terraform e AWS e entender como essas ferramentas se relacionam. 

## Objetivo principal
Obter skill em IaC e fazer o deploy de uma aplicação na AWS usando EC2.


## Requerimentos e ferramentas
1. [Terraform](https://developer.hashicorp.com/terraform/install)
2. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
3. [Conta na AWS](https://aws.amazon.com/)
4. [Nodejs](https://nodejs.org/en/download)

## Configurar SSH AWS


## Deploy da infraestrutura
#### Clonar repositório

    git clone git@github.com:pcalves1/terraform-ansible-aws-lab.git

#### Inicie o terraform
No terminal, navegue nas pastas para iniciar a configuração do terraform com o comando `terraform init` execute esse comando nas duas pastas abaixo

    cd terraform-ansible-aws-lab/infra/aws-base
    cd terraform-ansible-aws-lab/infra/dev

Na pasta *terraform-ansible-aws-lab/infra/dev* execute o comando terraform plan

To deploy our terraform code first of all we need to create account on https://app.terraform.io/session and create organization and workspace.

## Deploy da aplicação


## Remover Infrastrutura

