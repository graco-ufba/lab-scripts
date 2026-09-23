#!/bin/bash
# Instala o serviço de sincronização de hora
# Uso: sudo bash -c "$(wget -qO- https://raw.githubusercontent.com/graco-ufba/lab-scripts/main/install-sync-hora.sh)"

set -e  # para em qualquer erro
export DEBIAN_FRONTEND=noninteractive

GITHUB_RAW="https://raw.githubusercontent.com/graco-ufba/lab-scripts/main"

echo "========================================="
echo "  Instalando sync-hora.service..."
echo "========================================="

# ----------------------------------------
# 1. Baixa o script de sincronização
# ----------------------------------------
echo "→ Baixando lab-sync-hora.sh..."
wget -q "$GITHUB_RAW/lab-sync-hora.sh" -O /usr/local/sbin/lab-sync-hora.sh

# ✅ Permissões aplicadas DENTRO do script
chmod +x /usr/local/sbin/lab-sync-hora.sh
chown root:root /usr/local/sbin/lab-sync-hora.sh

# ----------------------------------------
# 2. Baixa o serviço systemd
# ----------------------------------------
echo "→ Baixando lab-sync-hora.service..."
wget -q "$GITHUB_RAW/lab-sync-hora.service" -O /etc/systemd/system/lab-sync-hora.service

# ✅ Permissões do .service
chmod 644 /etc/systemd/system/lab-sync-hora.service
chown root:root /etc/systemd/system/lab-sync-hora.service

# ----------------------------------------
# 3. Ativa e inicia o serviço
# ----------------------------------------
echo "→ Ativando serviço..."
systemctl daemon-reload
systemctl enable lab-sync-hora.service
systemctl restart lab-sync-hora.service

# ----------------------------------------
# 4. Verificação
# ----------------------------------------
sleep 1

if systemctl is-active --quiet lab-sync-hora.service; then
    echo ""
    echo "✅ Serviço instalado e rodando!"
    echo ""
    systemctl status lab-sync-hora.service --no-pager
else
    echo ""
    echo "❌ Falha ao iniciar o serviço."
    echo "   Verifique com: journalctl -u lab-sync-hora.service -n 50"
    exit 1
fi

echo ""
echo "========================================="
echo "  INSTALAÇÃO CONCLUÍDA"
echo "========================================="
echo ""
echo "📋 Comandos úteis:"
echo "   Ver status:   systemctl status lab-sync-hora"
echo "   Ver logs:     journalctl -u lab-sync-hora -n 50"
echo "   Rodar agora:  systemctl restart lab-sync-hora"
echo ""
exit 0
