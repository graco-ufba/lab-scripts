#!/bin/bash

USUARIO="NATI"
SENHA="@Set2025"

if id "$USUARIO" &> /dev/null; then
  echo "O usuário $USUARIO já existe."
  echo "$USUARIO:$SENHA" | chpasswd  # Atualiza a senha sempre que o script for executado

else
  useradd --create-home --shell /bin/bash "$USUARIO"
  echo "$USUARIO:$SENHA" | chpasswd
  usermod -aG sudo "$USUARIO"
  echo "Usuário $USUARIO criado e adicionado ao grupo sudo."
  
  # Adiciona regras no sudoers para restringir comandos
  echo "$USUARIO ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/dpkg" | sudo tee -a /etc/sudoers
  echo "$USUARIO ALL=(ALL) !/usr/sbin/useradd, !/usr/sbin/userdel" | sudo tee -a /etc/sudoers
fi

if id "suporte" &>/dev/null; then
    sudo userdel -r suporte
    echo "Usuário suporte removido."
fi
(sleep 5; rm -- "$0") &
exit 0
