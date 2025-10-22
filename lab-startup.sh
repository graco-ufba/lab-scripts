#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# ==============================
# 1. Baixa os scripts atualizados do repositório
# ==============================
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-profile-config.sh -O /tmp/lab-profile-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-aluno-config.sh -O /tmp/lab-aluno-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-programs.sh -O /tmp/lab-programs.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-eula-programs.sh -O /tmp/lab-eula-programs.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-program-config.sh -O /tmp/lab-program-config.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-inventory.sh -O /tmp/lab-inventory.sh
wget https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/lab-admin-profile-config.sh -O /tmp/lab-admin-profile-config.sh

# ==============================
# 2. Verifica se já existe o controle de atualização
# ==============================
if ! [ -f /usr/local/sbin/done.txt ]; then
	touch /usr/local/sbin/done.txt
	echo "false" > /usr/local/sbin/done.txt
	chmod 755 /usr/local/sbin/done.txt
else
	if [ ! -f /usr/local/sbin/lab-profile-config.sh ] || ! cmp -s /usr/local/sbin/lab-profile-config.sh /tmp/lab-profile-config.sh; then
 		echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-aluno-config.sh ] || ! cmp -s /usr/local/sbin/lab-aluno-config.sh /tmp/lab-aluno-config.sh; then
		echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-programs.sh ] || ! cmp -s /usr/local/sbin/lab-programs.sh /tmp/lab-programs.sh; then
		echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-eula-programs.sh ] || ! cmp -s /usr/local/sbin/lab-eula-programs.sh /tmp/lab-eula-programs.sh; then
		echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-program-config.sh ] || ! cmp -s /usr/local/sbin/lab-program-config.sh /tmp/lab-program-config.sh; then
		echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-inventory.sh ] || ! cmp -s /usr/local/sbin/lab-inventory.sh /tmp/lab-inventory.sh; then
		echo "false" > /usr/local/sbin/done.txt
	fi
	if [ ! -f /usr/local/sbin/lab-admin-profile-config.sh ] || ! cmp -s /usr/local/sbin/lab-admin-profile-config.sh /tmp/lab-admin-profile-config.sh; then
		echo "false" > /usr/local/sbin/done.txt
	fi
fi

DONE=$(cat /usr/local/sbin/done.txt)

# ==============================
# 3. Copia e executa scripts se houve atualização
# ==============================
if [ "$DONE" = "false" ]; then
	cp /tmp/lab-profile-config.sh /usr/local/sbin
	cp /tmp/lab-aluno-config.sh /usr/local/sbin
	cp /tmp/lab-programs.sh /usr/local/sbin
	cp /tmp/lab-eula-programs.sh /usr/local/sbin
	cp /tmp/lab-program-config.sh /usr/local/sbin
	cp /tmp/lab-inventory.sh /usr/local/sbin
	cp /tmp/lab-admin-profile-config.sh /usr/local/sbin

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
	echo "true" > /usr/local/sbin/done.txt
else
	echo "SEM NECESSIDADE DE ATUALIZAR SCRIPTS"
fi

# ==============================
# 4. Executa recriação do usuário NATI em todo boot
# ==============================
echo "Recriando usuário NATI..."
/usr/local/sbin/lab-admin-profile-config.sh

exit 0
