## Project overview
O propósito desse laboratório é por em prática os conhecimentos de Ansible, Terraform e AWS e entender como essas ferramentas se relacionam. 

## Objetivo principal
Obter skill em IaC e fazer o deploy de uma aplicação na AWS usando EC2.

## Requerimentos e ferramentas
Esse lab foi executado no linux Ubuntu. Alguns comandos/detalhes podem variar de acordo com SO usado
1. [Terraform](https://developer.hashicorp.com/terraform/install)
2. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
3. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

## Arquitetura do lab
- Provisionamento via terraform de duas EC2 com Ubuntu.
- Uma EC2 com Ubuntu que será usada para deixar o todo-list rodando em nodejs.
- Uma EC2 com Ubuntu que será o banco de dados MYSQL
- Ambas as máquinas serão gerenciadas pelo Ansible


## Criar chave SSH para acessar as instâncas EC2
Primeiramente precisamos preparar as configurações necessárias para executar o ambiente. Além de ter as ferramentas acima, deveremos criar uma chave SSH que será utilizada para acessar as máquinas EC2 e para gerenciá-las com o Ansible. No exemplo abaixo criaremos uma chamada `aws-iac-lab` que está sendo salva na pasta `~/.ssh`

    ssh-keygen -f ~/.ssh/aws-iac-lab -t rsa

Digite uma senha para a chave ou deixe em branco. 



## Login AWS CLI
No console da AWS vá em `IAM`, crie um usuário novo, dê permissão administrativa para ele e em seguida uma `Acess key` liberando acesso ao `CLI`... Salve as credenciais, pois iremos utilizar em seguida. No terminal execute o comando abaixo e coloque as informações da access key.

    aws configure

## Deploy da infraestrutura
#### Clonar repositório

    git clone git@github.com:pcalves1/terraform-ansible-aws-lab.git

#### Inicie o terraform
No terminal, navegue na pasta `terraform-ansible-aws-lab/infra/aws-base` e execute o comando `terraform init`

Repita o mesmo passo na pasta `terraform-ansible-aws-lab/infra/dev` onde contém o módulo onde estão os inputs de inicialização da infra e dê o comando `terraform init`
    
Na pasta `terraform-ansible-aws-lab/infra/dev` execute o comando `terraform plan` para se certificar do que será implementado. E depois o comando `terraform apply`

## Deploy da aplicação


#### Arquivo hosts Ansible
Adicione o IP de cada instância EC2 no arquivo `terraform-ansible-aws-lab/infra/dev/hosts`.
````
Antes: <<APP_IP>> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws-iac-lab

Depois: 123.123.123.123 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/aws-iac-lab
````

#### Vars
Faremos a mesma coisa para o arquivo de variáveis `terraform-ansible-aws-lab/infra/dev/ansible/vars/vars.yaml`. Iremos adicionar o IP de cada instância em seu devido lugar

````
Antes: todo_app_ip: "<<APP_IP>>"
Depois: todo_app_ip: "123.123.123.123"
````

#### Usuário e senha banco de dados
Ainda no arquivo `terraform-ansible-aws-lab/infra/dev/ansible/vars/vars.yaml` insira o nome de um usuário e senha para o banco de dados MYSQL. No arquivo substitua as linhas do usuário e senha como no exemplo a seguir:

mysql_user: "~~<<MYSQL_USER>>~~" <br>
mysql_user: "meu_user"


Agora navegue na pasta `terraform-ansible-aws-lab/infra/dev/ansible` para iniciar o playbook conforme o aquivo host

    ansible-playbook playbook.yaml -i hosts


## Acessando a aplicação
Depois do playbook ansible rodar e estiver tudo ok. No terminal navegue para a pasta `terraform-ansible-aws-lab/infra/dev` e rode o comando `terraform output`, copie o endereço do load balancer e cole no seu navegador 

## Remover Infraestrutura
Navegue na pasta `terraform-ansible-aws-lab/infra/dev` e execute o comando `terraform destroy` para desprovisionar a infra na AWS e não gerar custos além do necessário.

