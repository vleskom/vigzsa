#!/bin/sh
RED='\033[0;31m'
YEL='\033[0;33m'
GRE='\033[0;37m'
NC='\033[0m'
sqljelszo=kalifornia
IPCIM=$(ip address show | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
if ! [ $(id -u) = 0 ]; then
    echo "${RED}root jog szükséges ${GRE}(sudo sh setup.sh)"
    exit 1
fi
    echo "${YEL}»» rootjog ok!${NC}"
	echo "${YEL}»» apt update......${NC}"
	sudo apt update -y
	echo "${YEL}»» ssh telepítése......${NC}"
	sudo apt install openssh-server -y
	echo "${YEL}»» git, ansible telepítése......${NC}"
    sudo apt-add-repository ppa:ansible/ansible -y
    sudo apt update -y
	sudo apt install git software-properties-common ansible -y
    echo "${YEL}»» apt autoclean......${NC}"
    sudo apt autoclean -y && sudo apt autoremove -y
    echo "${YEL}Add meg a MySQL jelszavad [bármi lehet]:${NC}"
    read sqljelszo
    sudo ansible-playbook playbook.yml -i hosts -e mysql_root_password=$sqljelszo
    echo "${YEL} Virtuális gép IP címe:${NC} $IPCIM"