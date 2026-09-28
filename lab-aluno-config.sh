#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Reinstala pacotes gráficos importantes
sudo apt update
sudo apt install --reinstall -y accountsservice gnome-control-center

# Cria script de pós-login do GDM3 para o usuário 'aluno'
cat << 'EOF' > /etc/gdm3/PostLogin/Default
#!/bin/bash

if [[ "$USER" == "aluno" ]]; then
    rm -rf /home/$USER
    cp -r /etc/skel /home/$USER
    chown -R $USER:$USER /home/$USER
    echo "aluno:vivaoic2021!" | chpasswd

    echo 'export PATH="/opt/flutter/bin:$PATH"' >> /home/aluno/.bashrc
    echo 'export PATH="/opt/android-studio/bin:/opt/Android/Sdk/platform-tools:$PATH"' >> /home/aluno/.bashrc
    rm -f /opt/flutter/bin/cache/lockfile

  # Ferramentas instaladas pelo lab-programs.sh
    if [ -d /opt/nvm ]; then
        chown -R aluno:aluno /opt/nvm
    fi
    if [ -d /opt/sdkman ]; then
        chown -R aluno:aluno /opt/sdkman
    fi
    if [ -d /opt/miniforge3 ]; then
        chown -R aluno:aluno /opt/miniforge3
    fi

    # Docker Desktop / Docker Engine
    if getent group docker >/dev/null 2>&1; then
        usermod -aG docker aluno
    fi

    # Habilita o Docker Desktop para a sessão do aluno, quando o
    # barramento de usuário já estiver disponível.
    if [ -d "/run/user/$(id -u aluno)" ]; then
        runuser -u aluno -- env             XDG_RUNTIME_DIR="/run/user/$(id -u aluno)"             DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u aluno)/bus"             systemctl --user enable docker-desktop.service 2>/dev/null || true
    fi

    chown -R aluno:aluno /opt/flutter /opt/nand2tetris /opt/VMs

    mkdir -p /home/$USER/Unity/Hub
    ln -s /opt/Unity /home/$USER/Unity/Hub/Editor

    ln -s /opt/gradle /home/$USER/.gradle
    ln -s /opt/npm /home/$USER/.npm
    ln -s /opt/VMs /home/$USER/VirtualBox
    ln -s /opt/nand2tetris /home/$USER/nand2tetris

    # MySQL
    echo "DROP USER IF EXISTS 'aluno'@'localhost'; CREATE USER 'aluno'@'%' IDENTIFIED BY 'aluno'; GRANT ALL PRIVILEGES ON *.* TO 'aluno'@'%'; FLUSH PRIVILEGES;" | mysql -u root

    # PostgreSQL
    sudo -u postgres psql -c "DROP DATABASE IF EXISTS aluno;"
    sudo -u postgres psql -c "DROP USER IF EXISTS aluno;"
    sudo -u postgres psql -c "CREATE USER aluno WITH PASSWORD 'aluno';"
    sudo -u postgres psql -c "ALTER USER aluno WITH SUPERUSER;"
    sudo -u postgres psql -c "CREATE DATABASE aluno OWNER aluno;"

    sudo sed -i "s/local\s*all\s*postgres\s*peer/local all postgres md5/" /etc/postgresql/*/main/pg_hba.conf
    sudo sed -i "s/local\s*all\s*all\s*peer/local all all md5/" /etc/postgresql/*/main/pg_hba.conf
    sudo systemctl restart postgresql

    # Inventário
    inventory_path="/etc/gdm3/PostLogin/inventory_script-master"
    inventory_url='https://inventario.app.ic.ufba.br/inventory'
    python3 $inventory_path/src/inventory.py $inventory_url &> /var/log/inventory.log
fi

exit 0
EOF

chmod a+x /etc/gdm3/PostLogin/Default
echo '' > /etc/gdm3/PostSession/Default

# Backup dos scripts originais, se existirem
[[ -f /etc/gdm3/PostLogin/Default.bak ]] || sudo mv /etc/gdm3/PostLogin/Default /etc/gdm3/PostLogin/Default.bak
[[ -f /etc/gdm3/PostSession/Default.bak ]] || sudo mv /etc/gdm3/PostSession/Default /etc/gdm3/PostSession/Default.bak || true
sudo systemctl restart gdm3

exit 0
