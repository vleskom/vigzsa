#! /bin/bash
# ansible és wordpress install

sudo apt-get update
sudo apt-get install software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible -y
sudo apt-get install ssh -y
git clone https://github.com/andreipak/wordpress-ansible
cd wordpress-ansible
sudo ansible-playbook playbook.yml -i hosts -e mysql_root_password=123456
