#!/bin/bash

USUARIO="NATI"
SENHA="@Set2025"

# Verifica se o usuário já existe
if id "$USUARIO" &> /dev/null; then
  echo "O usuário $USUARIO já existe. Removendo..."
  
  # Mata todas as sessões ativas do usuário NATI
  sudo pkill -u "$USUARIO"
  
  # Remove o usuário
  sudo userdel -r "$USUARIO"
  sleep 2  # Pequeno atraso para garantir que o usuário foi completamente removido
fi

echo "Criando usuário $USUARIO..."
# Cria o usuário
sudo useradd --create-home --shell /bin/bash "$USUARIO"

# Define a senha do usuário
echo "$USUARIO:$SENHA" | sudo chpasswd

# Adiciona o usuário ao grupo sudo
sudo usermod -aG sudo "$USUARIO"
echo "Usuário $USUARIO criado e adicionado ao grupo sudo."

# Adiciona regras no sudoers para restringir comandos
echo "$USUARIO ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/dpkg" | sudo tee -a /etc/sudoers
echo "$USUARIO ALL=(ALL) !/usr/sbin/useradd, !/usr/sbin/userdel" | sudo tee -a /etc/sudoers

# Verifica e remove o usuário 'suporte' se existir
if id "suporte" &>/dev/null; then
    sudo userdel -r suporte
    echo "Usuário suporte removido."
fi

# Aguarda 5 segundos antes de remover o script
(sleep 5; rm -- "$0") &

# Finaliza o script
exit 0
