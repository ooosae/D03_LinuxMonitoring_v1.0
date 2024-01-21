#!/bin/bash

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

# Чтение конфигурационного файла, если он существует
config_file="config.txt"
if [ -e "$config_file" ]; then
  source "$config_file"
else
  column1_background=6
  column1_font_color=1
  column2_background=6
  column2_font_color=1
fi

# Проверка всех 4 параметров на соответствие диапазону
if validate_color "$column1_background" && validate_color "$column1_font_color" && validate_color "$column2_background" && validate_color "$column2_font_color"; then
 :
else
  exit 3
fi

bg_names=("47" "41" "42" "44" "45" "40")  # Фоны (соответственно к числам 1-6)
fg_names=("37" "31" "32" "34" "35" "30")  # Шрифты (соответственно к числам 1-6)

# Функция для получения цвета по номеру или "default"
get_color() {
  local color="$1"
  case $color in
    "1") echo "white" ;;
    "2") echo "red" ;;
    "3") echo "green" ;;
    "4") echo "blue" ;;
    "5") echo "purple" ;;
    "6") echo "black" ;;
    *) echo "default" ;;
  esac
}

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
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "HOSTNAME=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$HOSTNAME")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "TIMEZONE=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "UTC $TIMEZONE_OFFSET")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "USER=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$USER")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "OS=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$OS")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "DATE=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$DATE")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "UPTIME=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}"  "$UPTIME")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "UPTIME_SEC=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$UPTIME_SEC")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "IP=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$IP")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "MASK=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$MASK")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "GATEWAY=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$GATEWAY")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "RAM_TOTAL=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$RAM_TOTAL GB")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "RAM_USED=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$RAM_USED GB")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "RAM_FREE=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}""$RAM_FREE GB")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "SPACE_ROOT=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$SPACE_ROOT MB")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "SPACE_ROOT_USED=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$SPACE_ROOT_USED MB")"
print_colored_text "${bg_names[$column1_background-1]}" "${fg_names[$column1_font_color-1]}" "SPACE_ROOT_FREE=$(print_colored_text "${bg_names[$column2_background-1]}" "${fg_names[$column2_font_color-1]}" "$SPACE_ROOT_FREE MB")"

echo
# Вывод цветовой схемы
if [ -e "$config_file" ]; then
	echo "Column 1 background = $column1_background ($(get_color "$column1_background"))"
	echo "Column 1 font color = $column1_font_color ($(get_color "$column1_font_color"))"
	echo "Column 2 background = $column2_background ($(get_color "$column2_background"))"
	echo "Column 2 font color = $column2_font_color ($(get_color "$column2_font_color"))"
  	
else
	echo "Column 1 background = default (black)"
	echo "Column 1 font color = default (white)"
	echo "Column 2 background = default (black)"
	echo "Column 2 font color = default (white)"
fi

