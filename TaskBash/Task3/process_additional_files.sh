#!/bin/bash

# Директория для сканирования
DIRECTORY="."

# Обход подкаталогов
for dir in "$DIRECTORY"/*; do
  if [ -d "$dir" ]; then
    # Обход файлов в подкаталоге
    for file in "$dir"/*; do
      if [ -f "$file" ]; then
        # Разделение имени файла на основное и дополнительное
        base_name="${file%.*}"
        ext="${file##*.}"
        if [ "$ext" != "$file" ]; then
          # Дополнительный файл
          if [ ! -f "${base_name}" ]; then
            # Нет основного файла
            count=0
            for f in "$dir"/*; do
              if [ -f "$f" ] && [ "${f%.*}" = "${base_name}" ]; then
                ((count++))
              fi
            done
            if [ $count -eq 1 ]; then
              # Переименовать дополнительный файл в основной
              mv "$file" "${base_name}"
            elif [ $count -gt 1 ]; then
              # Вывести сообщение об ошибке
              echo "Ошибка: в подкаталоге $dir найдено несколько дополнительных файлов"
            fi
          else
            # Есть основной файл
            main_size=$(stat -c%s "${base_name}")
            max_size=0
            max_file=""
            for f in "$dir"/*; do
              if [ -f "$f" ] && [ "${f%.*}" = "${base_name}" ]; then
                size=$(stat -c%s "$f")
                if [ $size -gt $max_size ]; then
                  max_size=$size
                  max_file="$f"
                fi
              fi
            done
            if [ $max_size -gt $main_size ]; then
              # Переименовать дополнительный файл в основной
              mv "$max_file" "${base_name}"
              # Удалить остальные дополнительные файлы
              for f in "$dir"/*; do
                if [ -f "$f" ] && [ "${f%.*}" = "${base_name}" ] && [ "$f" != "$max_file" ]; then
                  rm "$f"
                fi
              done
            else
              # Удалить дополнительные файлы
              for f in "$dir"/*; do
                if [ -f "$f" ] && [ "${f%.*}" = "${base_name}" ]; then
                  rm "$f"
                fi
              done
            fi
          fi
        fi
      fi
    done
  fi
done
