#!/bin/bash
cd /home/ubuntu
sudo apt update
sudo apt install -y python3 python3-pip
sudo apt install -y ansible
sudo echo "MYSQL_HOST='${mysql_addr}'" >> /etc/environment
sudo echo "MYSQL_PASSWORD='${mysql_password}'" >> /etc/environment
sudo echo "MYSQL_DATABASE='todo_items'" >> /etc/environment
sudo echo "MYSQL_USER='${mysql_user}'" >> /etc/environment

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
      cmd: cd /home/ubuntu/todo-app && MYSQL_HOST=${mysql_addr} MYSQL_PASSWORD=${mysql_password} MYSQL_DATABASE="todo_items" MYSQL_USER=${mysql_user} node src/index;js


EOT
ansible-playbook playbook.yml -vvv > /home/ubuntu/app-starter.log
# sudo rm -fr /home/ubuntu/playbook.yml