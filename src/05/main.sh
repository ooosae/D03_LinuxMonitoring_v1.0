#!/bin/bash

start_time=$(date +%s.%N)

# Проверяем, передан ли аргумент
if [ "$#" -ne 1 ]; then
  exit 1
fi

# Получаем абсолютный путь к указанной директории
directory_path=$(realpath "$1")

# Проверяем, существует ли указанная директория
if [ ! -d "$directory_path" ]; then
  exit 2
fi

# Функция для вычисления размера директории
calculate_directory_size() {
  local size=$(du -sh "$1" | awk '{print $1}')
  echo "$size"
}

# Функция для вычисления MD5 хэша файла
calculate_md5_hash() {
  local md5_hash=$(md5sum "$1" | awk '{print $1}')
  echo "$md5_hash"
}

# Подсчет количества папок и файлов
total_folders=$(find "$directory_path" -type d | wc -l)
total_files=$(find "$directory_path" -type f | wc -l)

# Подсчет количества файлов различных типов
config_files=$(find "$directory_path" -type f -name "*.conf" | wc -l)
text_files=$(find "$directory_path" -type f -exec file {} \; | grep -c "text")
executable_files=$(find "$directory_path" -type f -executable | wc -l)
log_files=$(find "$directory_path" -type f -name "*.log" | wc -l)
archive_files=$(find "$directory_path" -type f \( -name "*.zip" -o -name "*.tar" -o -name "*.gz" \) | wc -l)
symbolic_links=$(find "$directory_path" -type l | wc -l)

# Подсчет и вывод топ 5 папок с наибольшим размером
top_folders=$(du -h --max-depth=1 "$directory_path" 2>/dev/null | sort -rh | head -n 6 | tail -n 5)
top_folders_output=""
index=1
while IFS=$'\t' read -r size folder; do
  top_folders_output+="$index - $folder, $size\n"
  ((index++))
done <<< "$top_folders"

# Подсчет и вывод топ 10 файлов с наибольшим размером и их типов
top_files=$(find "$directory_path" -type f -exec du -h {} \; 2>/dev/null | sort -rh | head -n 11 | tail -n 10)
top_files_output=""
index=1
while IFS=$'\t' read -r size file; do
  file_type=$(file -b --mime-type "$file")
  top_files_output+="$index - $file, $size, $file_type\n"
  ((index++))
done <<< "$top_files"

# Подсчет и вывод топ 10 исполняемых файлов с наибольшим размером и их MD5 хэшей
top_executable_files=$(find "$directory_path" -type f -executable -exec du -h {} \; 2>/dev/null | sort -rh | head -n 11 | tail -n 10)
top_executable_files_output=""
index=1
while IFS=$'\t' read -r size file; do
  md5_hash=$(calculate_md5_hash "$file")
  top_executable_files_output+="$index - $file, $size, $md5_hash\n"
  ((index++))
done <<< "$top_executable_files"

end_time=$(date +%s.%N)
script_execution_time=$(echo "$end_time - $start_time" | bc)

# Вывод информации
echo "Total number of folders (including all nested ones) = $total_folders"
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
echo -e "$top_folders_output"
echo "Total number of files = $total_files"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $config_files"
echo "Text files = $text_files"
echo "Executable files = $executable_files"
echo "Log files (with the extension .log) = $log_files"
echo "Archive files = $archive_files"
echo "Symbolic links = $symbolic_links"
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
echo -e "$top_files_output"
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash):"
echo -e "$top_executable_files_output"
echo "Script execution time (in seconds) = $script_execution_time"

