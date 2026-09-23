#!/bin/bash
# Sincroniza data e hora no boot
# Não baixa nem reinstala nada

export DEBIAN_FRONTEND=noninteractive

echo "========================================="
echo "  Sincronizando data e hora..."
echo "========================================="

timedatectl set-ntp true
timedatectl set-timezone America/Bahia
timedatectl set-local-rtc 0
systemctl restart systemd-timesyncd

echo ""
echo "Status da sincronização:"
timedatectl status

echo ""
echo "✅ Hora sincronizada com sucesso."
exit 0
