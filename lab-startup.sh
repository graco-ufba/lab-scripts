#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-profile-config.sh -O /tmp/lab-profile-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-aluno-config.sh -O /tmp/lab-aluno-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-programs.sh -O /tmp/lab-programs.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-eula-programs.sh -O /tmp/lab-eula-programs.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-program-config.sh -O /tmp/lab-program-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-inventory.sh -O /tmp/lab-inventory.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-admin-profile-config.sh -O /tmp/lab-admin-profile-config.sh



if ! [ -f /usr/local/sbin/done.txt ]; then
	sudo touch /usr/local/sbin/done.txt
	#sudo echo "false" > /usr/local/sbin/done.txt
 	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
	chmod 755 /usr/local/sbin/done.txt
else
	if [ ! -f /usr/local/sbin/lab-profile-config.sh ] || ! cmp -s /usr/local/sbin/lab-profile-config.sh /tmp/lab-profile-config.sh; then
 	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-aluno-config.sh ] || ! cmp -s /usr/local/sbin/lab-aluno-config.sh /tmp/lab-aluno-config.sh; then
	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
 	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-programs.sh ] || ! cmp -s /usr/local/sbin/lab-programs.sh /tmp/lab-programs.sh; then
	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
 	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-eula-programs.sh ] || ! cmp -s /usr/local/sbin/lab-eula-programs.sh /tmp/lab-eula-programs.sh; then
	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
 	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-program-config.sh ] || ! cmp -s /usr/local/sbin/lab-program-config.sh /tmp/lab-program-config.sh; then
	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
 	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-inventory.sh ] || ! cmp -s /usr/local/sbin/lab-inventory.sh /tmp/lab-inventory.sh; then
	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
 	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-admin-profile-config.sh ] || ! cmp -s /usr/local/sbin/lab-admin-profile-config.sh /tmp/lab-admin-profile-config.sh; then
	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
 	#sudo echo "false" > /usr/local/sbin/done.txt
	fi
fi

DONE=$(cat /usr/local/sbin/done.txt)

if [ "$DONE" = "false" ]; then
	sudo cp /tmp/lab-profile-config.sh /usr/local/sbin
	sudo cp /tmp/lab-aluno-config.sh /usr/local/sbin
	sudo cp /tmp/lab-programs.sh /usr/local/sbin
	sudo cp /tmp/lab-eula-programs.sh /usr/local/sbin
 	sudo cp /tmp/lab-program-config.sh /usr/local/sbin
	sudo cp /tmp/lab-inventory.sh /usr/local/sbin
 	sudo cp /tmp/lab-admin-profile-config.sh /usr/local/sbin

	chmod 755 /usr/local/sbin/lab-profile-config.sh
	chmod 755 /usr/local/sbin/lab-aluno-config.sh
	chmod 755 /usr/local/sbin/lab-programs.sh
	chmod 755 /usr/local/sbin/lab-eula-programs.sh
 	chmod 755 /usr/local/sbin/lab-program-config.sh
	chmod 755 /usr/local/sbin/lab-inventory.sh
 	chmod 755 /usr/local/sbin/lab-admin-profile-config.sh

	/usr/local/sbin/lab-profile-config.sh
	/usr/local/sbin/lab-aluno-config.sh
	/usr/local/sbin/lab-programs.sh
	/usr/local/sbin/lab-eula-programs.sh
 	/usr/local/sbin/lab-program-config.sh
	/usr/local/sbin/lab-inventory.sh
 	/usr/local/sbin/lab-admin-profile-config.sh

	rm -f /tmp/lab-admin-profile-config.sh

	echo "SCRIPTS ATUALIZADOS"
 	echo "false" | sudo tee /usr/local/sbin/done.txt > /dev/null
else
	echo "SEM NECESSIDADE DE ATUALIZAR SCRIPTS"
fi

exit 0
