#!/bin/bash
cd /home/ubuntu
sudo apt update
sudo apt install -y python3 python3-pip
sudo apt install -y ansible
sudo apt install -y unzip

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

mysql_creds=$(aws secretsmanager get-secret-value --secret-id ${mysql_credentials} --region ${aws_region} | jq -r '.SecretString')
mysql_user=$(echo $mysql_creds | jq -r '.username')
mysql_password=$(echo $mysql_creds | jq -r '.password')

sudo echo "MYSQL_HOST='${mysql_addr}'" >> /etc/environment
sudo echo "MYSQL_PASSWORD=$(echo $mysql_creds | jq -r '.password')" >> /etc/environment
sudo echo "MYSQL_DATABASE='todo_items'" >> /etc/environment
sudo echo "MYSQL_USER=$(echo $mysql_creds | jq -r '.username')" >> /etc/environment

tee -a playbook.yml > /dev/null <<EOT

- hosts: localhost
  tasks:

  - name: Clone todo-app
    ansible.builtin.git:
      repo: https://github.com/pcalves1/todo-app.git
      dest: /home/ubuntu/todo-app
      version: main
      force: true
      
  - name: Install nodejs and npm
    apt:
      pkg:
        - nodejs
        - npm
      update_cache: true
    become: true

  - name: Install packages based on package.json
    ansible.builtin.shell: |
      cd /home/ubuntu/todo-app; npm i 

  - name: Start project
    ansible.builtin.shell: 
      cmd: cd /home/ubuntu/todo-app &&  npm run prod


EOT
MYSQL_HOST=${mysql_addr} MYSQL_PASSWORD=$(echo $mysql_creds | jq -r '.password') MYSQL_DATABASE="todo_items" MYSQL_USER=$(echo $mysql_creds | jq -r '.username') ansible-playbook playbook.yml -vvv > /home/ubuntu/app-starter.log