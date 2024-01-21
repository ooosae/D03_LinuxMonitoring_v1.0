# Функция для вывода текста с заданными цветами
print_colored_text() {
  local bg_name fg_name text
  bg_name=$1
  fg_name=$2
  text=$3
  echo -e "\e[${bg_name};${fg_name}m${text}\e[0m"
}

# Функция для проверки, что число находится в диапазоне от 1 до 6
validate_color() {
  local color="$1"
  if [[ "$color" =~ ^[1-6]$ ]]; then
    return 0
  else
    return 1
  fi
}

#!/bin/bash

if [ "$#" -ne 4 ]; then
  exit 1
fi


# Проверка на совпадение цветов
if [ "$1" == "$2" ] || [ "$3" == "$4" ]; then
  echo "Ошибка: Цвета шрифта и фона должны быть разными."
  
  # Предложение ввести новые параметры
  while true; do
    read -p "Хотите ввести новые параметры? (Y/N): " response
    case $response in
      [Yy]* )
        read -p "Введите фон названий значений (1-6): " new_bg_title
        read -p "Введите цвет шрифта названий значений (1-6): " new_fg_title
        read -p "Введите фон значений (1-6): " new_bg_value
        read -p "Введите цвет шрифта значений (1-6): " new_fg_value
		exec bash "$0" "$new_bg_title" "$new_fg_title" "$new_bg_value" "$new_fg_value"
        ;;
      * )
        exit 2
        ;;
    esac
  done
fi

# Проверка всех 4 параметров на соответствие диапазону
if validate_color "$1" && validate_color "$2" && validate_color "$3" && validate_color "$4"; then
 :
else
  exit 3
fi

bg_names=("47" "41" "42" "44" "45" "40")  # Фоны (соответственно к числам 1-6)
fg_names=("37" "31" "32" "34" "35" "30")  # Шрифты (соответственно к числам 1-6)


# Получаем данные
HOSTNAME=$(hostname)
TIMEZONE=$(timedatectl show --property=Timezone --value)
TIMEZONE_OFFSET=$(date +"%:z")
USER=$(whoami)
OS=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '"')
DATE=$(date +"%d %B %Y %T")
UPTIME=$(w | grep up | awk -F' ' '{print $3}' | sed 's/,//')
UPTIME_SEC=$(cat /proc/uptime | awk -F ' ' '{print $1}')
IP=$(ifconfig | grep "inet " | awk -F' ' 'NR == 1 {print $2}')
MASK=$(ifconfig | grep "netmask " | awk -F' ' 'NR == 1 {print $4}')
GATEWAY=$(ip route | grep default | awk '{print $3}')
RAM_TOTAL=$(free | grep Mem | awk -F' ' '{printf "%.3f\n", $2/(1024*1024)}')
RAM_USED=$(free | grep Mem | awk -F' ' '{printf "%.3f\n", $3/(1024*1024)}')
RAM_FREE=$(free | grep Mem | awk -F' ' '{printf "%.3f\n", $4/(1024*1024)}')
SPACE_ROOT=$(df / | tail -n +2 | head -1 | awk -F' ' '{printf "%.2f\n", $2/(1024)}')
SPACE_ROOT_USED=$(df / | tail -n +2 | head -1 | awk -F' ' '{printf "%.2f\n", $3/(1024)}')
SPACE_ROOT_FREE=$(df / | tail -n +2 | head -1 | awk -F' ' '{printf "%.2f\n", $4/(1024)}')

# Выводим данные на экран с заданными цветами
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "HOSTNAME=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$HOSTNAME")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "TIMEZONE=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$TIMEZONE UTC $TIMEZONE_OFFSET")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "USER=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$USER")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "OS=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$OS")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "DATE=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$DATE")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "UPTIME=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$UPTIME")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "UPTIME_SEC=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$UPTIME_SEC")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "IP=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$IP")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "MASK=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$MASK")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "GATEWAY=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$GATEWAY")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "RAM_TOTAL=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$RAM_TOTAL GB")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "RAM_USED=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$RAM_USED GB")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "RAM_FREE=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$RAM_FREE GB")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "SPACE_ROOT=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$SPACE_ROOT MB")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "SPACE_ROOT_USED=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$SPACE_ROOT_USED MB")"
print_colored_text "${bg_names[$1-1]}" "${fg_names[$2-1]}" "SPACE_ROOT_FREE=$(print_colored_text "${bg_names[$3-1]}" "${fg_names[$4-1]}" "$SPACE_ROOT_FREE MB")"

