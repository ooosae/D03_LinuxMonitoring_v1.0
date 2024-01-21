#!/bin/bash

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

# Выводим данные на экран
echo "HOSTNAME=$HOSTNAME"
echo "TIMEZONE=$TIMEZONE UTC $TIMEZONE_OFFSET"
echo "USER=$USER"
echo "OS=$OS"
echo "DATE=$DATE"
echo "UPTIME=$UPTIME"
echo "UPTIME_SEC=$UPTIME_SEC"
echo "IP=$IP"
echo "MASK=$MASK"
echo "GATEWAY=$GATEWAY"
echo "RAM_TOTAL=$RAM_TOTAL GB"
echo "RAM_USED=$RAM_USED GB"
echo "RAM_FREE=$RAM_FREE GB"
echo "SPACE_ROOT=$SPACE_ROOT MB"
echo "SPACE_ROOT_USED=$SPACE_ROOT_USED MB"
echo "SPACE_ROOT_FREE=$SPACE_ROOT_FREE MB"

# Запрос на сохранение в файл
read -p "Желаете сохранить данные в файл (Y/N)? " response
if [[ "$response" == "Y" || "$response" == "y" ]]; then
  CURRENT_TIME=$(date +"%d_%m_%y_%H_%M_%S")
  FILENAME="${CURRENT_TIME}.status"
  {
	echo "HOSTNAME=$HOSTNAME"
	echo "TIMEZONE=$TIMEZONE UTC $TIMEZONE_OFFSET"
	echo "USER=$USER"
	echo "OS=$OS"
	echo "DATE=$DATE"
	echo "UPTIME=$UPTIME"
	echo "UPTIME_SEC=$UPTIME_SEC"
	echo "IP=$IP"
	echo "MASK=$MASK"
	echo "GATEWAY=$GATEWAY"
	echo "RAM_TOTAL=$RAM_TOTAL GB"
	echo "RAM_USED=$RAM_USED GB"
	echo "RAM_FREE=$RAM_FREE GB"
	echo "SPACE_ROOT=$SPACE_ROOT MB"
	echo "SPACE_ROOT_USED=$SPACE_ROOT_USED MB"
	echo "SPACE_ROOT_FREE=$SPACE_ROOT_FREE MB"
  } > "$FILENAME"
  echo "Данные сохранены в файл: $FILENAME"
fi

