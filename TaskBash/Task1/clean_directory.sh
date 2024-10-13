#!/bin/bash

# Проверяем количество параметров
if [ $# -ne 2 ]; then
  echo "Ошибка: не указаны необходимые параметры"
  echo "Использование: $0 <директория_N> <версия>"
  exit 1
fi

# Устанавливаем переменные
DIR_N=$1
VERSION=$2

# Проверяем существование директории
if [ ! -d "$DIR_N" ]; then
  echo "Ошибка: директория '$DIR_N' не существует"
  exit 1
fi

# Проверяем формат версии
if ! [[ $VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Ошибка: неверный формат версии '$VERSION'"
  exit 1
fi

# Удаляем папки с версиями старше заданной
for dir in "$DIR_N"/*; do
  if [ -d "$dir" ]; then
    dir_version=$(basename "$dir" | sed 's/^[^_]*_//')
    if [ -n "$dir_version" ]; then
      if ! [[ $dir_version =~ ^[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
        continue
      fi
      if [ "$(printf '%s\n' "$VERSION" "$dir_version" | sort -V | head -n1)" = "$dir_version" ]; then
        echo "Удаляем папку '$dir'"
        rm -rf "$dir"
      fi
    fi
  fi
done
