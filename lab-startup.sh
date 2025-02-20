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
	sudo echo "false" > /usr/local/sbin/done.txt
	chmod 755 /usr/local/sbin/done.txt
else
	if ! cmp -s /usr/local/sbin/lab-profile-config.sh /tmp/lab-profile-config.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if ! cmp -s /usr/local/sbin/lab-aluno-config.sh /tmp/lab-aluno-config.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if ! cmp -s /usr/local/sbin/lab-programs.sh /tmp/lab-programs.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
	if ! cmp -s /usr/local/sbin/lab-eula-programs.sh /tmp/lab-eula-programs.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
 	if ! cmp -s /usr/local/sbin/lab-program-config.sh /tmp/lab-program-config.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
  	if ! cmp -s /usr/local/sbin/lab-inventory.sh /tmp/lab-inventory.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
	fi
 	if ! cmp -s /usr/local/sbin/lab-admin-profile-config.sh /tmp/lab-admin-profile-config.sh; then
	sudo echo "false" > /usr/local/sbin/done.txt
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
 	sudo echo "true" > /usr/local/sbin/done.txt
else
	echo "SEM NECESSIDADE DE ATUALIZAR SCRIPTS"
fi

exit 0
