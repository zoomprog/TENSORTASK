#!/bin/bash

# Список серверов в локальной сети
SERVERS=("server1" "server2" "server3" "192.168.1.100" "192.168.1.101")

# Имя пользователя и пароль для доступа к серверам
USERNAME="username"
PASSWORD="password"

# Операция, которую нужно выполнить на серверах
OPERATION="ls -l /path/to/directory"

# Обход серверов и выполнение операции
for SERVER in "${SERVERS[@]}"; do
  echo "Обрабатываем сервер $SERVER"
  sshpass -p "$PASSWORD" ssh -o "StrictHostKeyChecking=no" "$USERNAME@$SERVER" "$OPERATION"
done
