#!/bin/bash

# Каталоги источник и приемник
SRC_DIR=/var/data1
DST_DIR=/var/data2

# Копирование файлов с изменением структуры каталога
for file in "$SRC_DIR"/*/*/*/*; do
  # Разделение имени файла на компоненты
  version=$(dirname "$file" | cut -d '/' -f 1)
  name_service=$(dirname "$file" | cut -d '/' -f 2)
  build_number=$(dirname "$file" | cut -d '/' -f 3)
  filename=$(basename "$file")
  os=$(echo "$filename" | cut -d '_' -f 2)
  arch=$(echo "$filename" | cut -d '_' -f 3)
  ext=$(echo "$filename" | cut -d '.' -f 2)

  # Создание каталога приемника
  dst_dir="$DST_DIR/$name_service/$version/$build_number/$os_$arch"
  mkdir -p "$dst_dir"

  # Копирование файла с изменением структуры каталога
  if [ "$ext" = "7z" ]; then
    # Перепаковка архива 7z в zip
    7z e "$file" -o"$dst_dir"
    zip -r "$dst_dir/$filename.zip" "$dst_dir/*"
    rm -rf "$dst_dir"
  else
    # Копирование файла без изменения
    cp "$file" "$dst_dir/$filename"
  fi
done
