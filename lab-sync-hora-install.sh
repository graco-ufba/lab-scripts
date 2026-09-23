#!/bin/bash
# Instala o serviço de sincronização de hora
export DEBIAN_FRONTEND=noninteractive

GITHUB_RAW="https://raw.githubusercontent.com/graco-ufba/lab-scripts/main"

echo "========================================="
echo "  Instalando sync-hora.service..."
echo "========================================="

# Baixa o script de sincronização
wget -q "$GITHUB_RAW/lab-sync-hora.sh" -O /usr/local/sbin/lab-sync-hora.sh
chmod +x /usr/local/sbin/lab-sync-hora.sh
chown root:root /usr/local/sbin/lab-sync-hora.sh

# Baixa o serviço
wget -q "$GITHUB_RAW/lab-sync-hora.service" -O /etc/systemd/system/lab-sync-hora.service
chmod 644 /etc/systemd/system/lab-sync-hora.service

# Ativa o serviço
systemctl daemon-reload
systemctl enable lab-sync-hora.service
systemctl start lab-sync-hora.service

echo ""
echo "✅ Serviço instalado!"
echo ""
systemctl status lab-sync-hora.service --no-pager
exit 0
