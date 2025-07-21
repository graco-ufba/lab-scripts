#!/bin/bash
set -euo pipefail

USER="aluno"
HOME_DIR="/home/$USER"
INVENTORY_PATH="/etc/gdm3/PostLogin/inventory_script-master"
INVENTORY_URL="https://inventario.app.ic.ufba.br/inventory"
LOG_FILE="/var/log/reset-aluno.log"

# Só executa se o usuário for "aluno"
if [[ "$USER" == "aluno" ]]; then
    echo "[INFO] Resetando usuário $USER em $(date)" >> "$LOG_FILE"

    # Finaliza possíveis sessões existentes
    pkill -u "$USER" || true

    # Recria home
    rm -rf "$HOME_DIR"
    cp -r /etc/skel "$HOME_DIR"
    chown -R "$USER:$USER" "$HOME_DIR"

    # Atualiza senha
    echo "$USER:vivaoic2021!" | chpasswd

    # Configura variáveis de ambiente
    {
        echo 'export PATH="/opt/flutter/bin:$PATH"'
        echo 'export PATH="/opt/android-studio/bin:/opt/Android/Sdk/platform-tools:$PATH"'
    } >> "$HOME_DIR/.bashrc"

    # Ajusta permissões em /opt
    chown -R "$USER:$USER" /opt/flutter /opt/nand2tetris /opt/VMs || true

    # Cria links simbólicos
    mkdir -p "$HOME_DIR/Unity/Hub"
    ln -sfn /opt/Unity "$HOME_DIR/Unity/Hub/Editor"
    ln -sfn /opt/gradle "$HOME_DIR/.gradle"
    ln -sfn /opt/npm "$HOME_DIR/.npm"
    ln -sfn /opt/VMs "$HOME_DIR/VirtualBox"
    ln -sfn /opt/nand2tetris "$HOME_DIR/nand2tetris"
    chown -h "$USER:$USER" "$HOME_DIR"/Unity/Hub/Editor "$HOME_DIR"/.gradle "$HOME_DIR"/.npm \
        "$HOME_DIR"/VirtualBox "$HOME_DIR"/nand2tetris || true

    # Reconfigura banco de dados MySQL
    systemctl restart mysql || true
    mysql -u root <<EOF
DROP USER IF EXISTS 'aluno'@'localhost';
CREATE USER 'aluno'@'localhost' IDENTIFIED BY 'aluno';
GRANT ALL PRIVILEGES ON *.* TO 'aluno'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

    # Reconfigura banco de dados PostgreSQL
    sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS aluno;
DROP USER IF EXISTS aluno;
CREATE USER aluno WITH PASSWORD 'aluno' SUPERUSER;
CREATE DATABASE aluno OWNER aluno;
EOF

    # Ajusta pg_hba.conf (se necessário)
    PG_HBA=$(find /etc/postgresql/ -name pg_hba.conf | head -n1)
    if [[ -f "$PG_HBA" ]]; then
        sed -i 's/local\s\+all\s\+postgres\s\+peer/local all postgres md5/' "$PG_HBA"
        sed -i 's/local\s\+all\s\+all\s\+peer/local all all md5/' "$PG_HBA"
        systemctl restart postgresql
    fi

    # Executa inventário
    python3 "$INVENTORY_PATH/src/inventory.py" "$INVENTORY_URL" &>> /var/log/inventory.log || true

    echo "[INFO] Reset completo para $USER em $(date)" >> "$LOG_FILE"
fi

exit 0

