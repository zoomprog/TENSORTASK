import csv
from datetime import datetime
from pickle import PROTO
from statistics import mean, median
from collections import defaultdict


def parse_log_file(file_path):
    with open(file_path, 'r') as file:
        # Создаем объект для чтения CSV-файла с разделителем '|'
        reader = csv.reader(file, delimiter='|')
        processing_times = []
        error_count = 0
        total_requests = 0
        # Инициализируем словарь для подсчета количества вызовов каждой страницы
        page_calls = defaultdict(int)
        for row in reader:
            # Убираем пробелы и разбираем строку на компоненты
            start_time_str, end_time_str, req_path, resp_code, resp_body = map(str.strip, row)

            start_time = datetime.strptime(start_time_str, '%d.%m.%Y %H:%M:%S')
            end_time = datetime.strptime(end_time_str, '%d.%m.%Y %H:%M:%S')

            # Вычисляем время обработки в секунду
            processing_time = (end_time - start_time).total_seconds()
            processing_times.append(processing_time)

            total_requests += 1 # количество ошибок
            resp_code = int(resp_code)
            if resp_code >= 400 or resp_code == 'error':
                error_count += 1
            page_calls[req_path] += 1

        # времени обработки
        max_time = max(processing_times)
        min_time = min(processing_times)
        avg_time = mean(processing_times)
        median_time = median(processing_times)

        # % ошибок
        percent_error = (error_count/total_requests) * 100

    #Cтатистика времени обработки
    print(f'Максимум {max_time} секунд')
    print(f'Минимум {min_time} секунд')
    print(f'В среднем {avg_time} секунд')
    print(f'Медиана {median_time} секунд')

    print(f'Процент ошибок {percent_error:.2f}%')
    print('\nКоличество вызовов страниц')
    for page, count in page_calls.items():
        print(f'{page}: {count}')

parse_log_file('log.txt')