#!/bin/bash
set -e

USER=aluno
HOME_DIR="/home/$USER"

# Executa apenas se o login for do usuário aluno
if [[ "$USER" == "aluno" ]]; then

    # Garante que a home não esteja sendo usada
    pkill -u "$USER" || true

    # Recria a home
    rm -rf "$HOME_DIR"
    cp -r /etc/skel "$HOME_DIR"
    chown -R "$USER:$USER" "$HOME_DIR"

    # Atualiza senha
    echo "$USER:vivaoic2021!" | chpasswd

    # Adiciona PATHs
    echo 'export PATH="/opt/flutter/bin:$PATH"' >> "$HOME_DIR/.bashrc"
    echo 'export PATH="/opt/android-studio/bin:/opt/Android/Sdk/platform-tools:$PATH"' >> "$HOME_DIR/.bashrc"

    # Permissões
    chown -R aluno:aluno /opt/flutter /opt/nand2tetris /opt/VMs || true

    # Links simbólicos
    mkdir -p "$HOME_DIR/Unity/Hub"
    ln -sf /opt/Unity "$HOME_DIR/Unity/Hub/Editor"
    ln -sf /opt/gradle "$HOME_DIR/.gradle"
    ln -sf /opt/npm "$HOME_DIR/.npm"
    ln -sf /opt/VMs "$HOME_DIR/VirtualBox"
    ln -sf /opt/nand2tetris "$HOME_DIR/nand2tetris"

    # MySQL
    systemctl restart mysql || true
    mysql -u root <<EOF
DROP USER IF EXISTS 'aluno'@'localhost';
CREATE USER 'aluno'@'localhost' IDENTIFIED BY 'aluno';
GRANT ALL PRIVILEGES ON *.* TO 'aluno'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

    # PostgreSQL
    sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS aluno;
DROP USER IF EXISTS aluno;
CREATE USER aluno WITH PASSWORD 'aluno' SUPERUSER;
CREATE DATABASE aluno OWNER aluno;
EOF

    # Ajusta pg_hba.conf (compatível com várias versões)
    for conf in /etc/postgresql/*/main/pg_hba.conf; do
        sed -i 's/local\s\+all\s\+postgres\s\+peer/local all postgres md5/' "$conf"
        sed -i 's/local\s\+all\s\+all\s\+peer/local all all md5/' "$conf"
    done
    systemctl restart postgresql || true

    # Inventário
    inventory_path="/etc/gdm3/PostLogin/inventory_script-master"
    inventory_url='https://inventario.app.ic.ufba.br/inventory'
    python3 "$inventory_path/src/inventory.py" "$inventory_url" &> /var/log/inventory.log || true

    echo "[INFO] Reconfiguração de aluno concluída em $(date)" >> /var/log/reset-aluno.log
fi

exit 0
