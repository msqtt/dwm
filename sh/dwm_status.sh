#!/bin/bash

#/home/mosquito/Software/dwm/sh/trayer.sh &

way="wlan0"
rx_pre=$(cat /proc/net/dev | grep "$way" | awk -F' ' '{print $2}')
tx_pre=$(cat /proc/net/dev | grep "$way" | awk -F' ' '{print $10}')
rx_b="Kbs"
tx_b="Kbs"

while true; do
	if [ "$(ip address | grep enp | grep inet)" ]; then
		way="enp"
	else
		way="wlan0"
	fi

  batcheck=$(acpi -b | grep 'Battery 1')
  batinfo=""
  
  if [ -n $batcheck ] ;then
    batinfo=$(acpi -b)
  else
    batinfo=$batcheck
  fi


	battery=$(echo $batinfo | cut -d',' -f2 | cut -d' ' -f2)
	battery_st=$(echo $batinfo | cut -d',' -f1 | cut -d' ' -f3)
	vol=$(amixer get Master | grep 'Left:' | cut -d'[' -f2 | cut -d']' -f1)
	mute=$(amixer get Master | grep 'Left:' | cut -d'[' -f3 | cut -d']' -f1)
	rx_now=$(cat /proc/net/dev | grep "$way" | awk -F' ' '{print $2}')
	tx_now=$(cat /proc/net/dev | grep "$way" | awk -F' ' '{print $10}')

	if [ "$mute" == "on" ]; then
		mute="墳"
	else
		mute="婢"
	fi

	if [ "$battery_st" == "Charging" ]; then
		battery_st=""
	elif [ "$battery_st" == "Discharging" ]; then
		battery_st="ﮤ"
	elif [ "$battery_st" == "Full" ]; then
		battery_st=""
	else
		battery_st=""
	fi

	rx=$(expr $rx_now - $rx_pre)
	rx=$(expr $rx / 1024)
	tx=$(expr $tx_now - $tx_pre)
	tx=$(expr $tx / 1024)

	showC=""
	showX=0
	showXB=""
	if [ $rx -gt $tx ]; then
		showC=""
		showX=$rx
	else
		showC="祝"
		showX=$tx
	fi

	if [ $showX -gt 1024 ]; then
		showX=$(expr $showX / 1024)
		showXB="Ms"
	else
		showXB="Kbs"
	fi

	 xsetroot -name "[$way] $showC:$showX$showXB · $battery_st:$battery · $mute:$vol · $(date +"%a %m.%d %H:%M")"
	 # echo "[$way] $showC:$showX$showXB| $battery_st:$battery| $mute:$vol| $(date +"%a %m.%d %H:%M")"


	rx_pre=$rx_now
	tx_pre=$tx_now

	sleep 1

done
