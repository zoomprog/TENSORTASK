import os
import shutil
from tqdm import tqdm

def delete_directory_with_progress(directories):
    try:
        # Получаем список всех файлов и папок в указанной директории
        files_and_dirs = os.listdir(directories)
        total_items = len(files_and_dirs)
        print(total_items)

        # Используем tqdm для отображения прогресса
        with tqdm(total=total_items, desc="Удаление файлов и папок", unit="item") as pbar:
            for item in files_and_dirs:
                item_path = os.path.join(directories, item)
                try:
                    # Удаляем файл или папку
                    if os.path.isfile(item_path) or os.path.islink(item_path):
                        os.unlink(item_path)
                    elif os.path.isdir(item_path):
                        shutil.rmtree(item_path)
                except Exception as e:
                    print(f"Не удалось удалить {item_path}. Причина: {e}")
                finally:
                    pbar.update(1)
    except Exception as e:
        print(f"Произошла ошибка: {e}")


path = 'C:/Users/rrarr/Desktop/test'
delete_directory_with_progress(path)
