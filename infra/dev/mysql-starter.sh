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

sudo echo "TODO_APP_IP='${todo_app_ip}'" >> /etc/environment
sudo echo "MYSQL_PASSWORD=$(echo $mysql_creds | jq -r '.password')" >> /etc/environment
sudo echo "MYSQL_DATABASE='todo_items'" >> /etc/environment
sudo echo "MYSQL_USER=$(echo $mysql_creds | jq -r '.username')" >> /etc/environment
tee -a playbook.yml > /dev/null <<EOT

- hosts: localhost
  handlers:
    - name: restart mysql
      ansible.builtin.shell:
        cmd: systemctl restart mysql.service
      become: true

  tasks:
    - name: Install mysql
      apt:
        pkg:
          - mysql-server
          - python3-pymysql
        update_cache: true
      become: true
      notify:
        - restart mysql

    - name: Create a new database with name "{{ lookup('env', 'MYSQL_DATABASE') }}"
      community.mysql.mysql_db:
        name: "{{ lookup('env', 'MYSQL_DATABASE') }}"
        state: present
        login_unix_socket: /run/mysqld/mysqld.sock
      become: true
      notify:
        - restart mysql

    - name: Create database user and password with all database privileges
      community.mysql.mysql_user:
        name: "{{ lookup('env', 'MYSQL_USER') }}"
        password: "{{ lookup('env', 'MYSQL_PASSWORD') }}"
        priv: "{{ lookup('env', 'MYSQL_DATABASE') }}.*:ALL"
        state: present
        login_unix_socket: /run/mysqld/mysqld.sock
        host: "{{ item }}"
      with_items:
        - "localhost"
        - "127.0.0.1"
        - "10.0.%"
        - "{{ lookup('env', 'TODO_APP_IP') }}"
      become: true

    - name: Configure database
      ansible.builtin.replace:
        path: /etc/mysql/mysql.conf.d/mysqld.cnf
        regexp: "127.0.0.1"
        replace: "0.0.0.0"
      become: true
      notify:
        - restart mysql

    - name: Ensure MySQL database is present
      community.mysql.mysql_db:
        name: "{{ lookup('env', 'MYSQL_DATABASE') }}"
        state: present
        login_user: "{{ lookup('env', 'MYSQL_USER') }}"
        login_password: "{{ lookup('env', 'MYSQL_PASSWORD') }}"

    - name: Create items table in todo_items database
      community.mysql.mysql_query:
        login_user: "{{ lookup('env', 'MYSQL_USER') }}"
        login_password: "{{ lookup('env', 'MYSQL_PASSWORD') }}"
        login_db: "{{ lookup('env', 'MYSQL_DATABASE') }}"
        query: CREATE TABLE IF NOT EXISTS items (id varchar(36), name varchar(255), completed boolean) DEFAULT CHARSET utf8mb4
EOT
TODO_APP_IP=${todo_app_ip} MYSQL_PASSWORD=$(echo $mysql_creds | jq -r '.password') MYSQL_DATABASE=todo_items MYSQL_USER=$(echo $mysql_creds | jq -r '.username') ansible-playbook playbook.yml -vvv >> /home/ubuntu/mysql-starter.log
# sudo rm -fr /home/ubuntu/playbook.yml