#!/usr/bin/env bash

# cek status radio wifi
wifi_state=$(nmcli -t -f WIFI g)

# cek koneksi aktif
connected=$(nmcli -t -f STATE g)

# cek koneksi internet (ping)
ping -c 1 -W 1 8.8.8.8 &> /dev/null
has_internet=$?

if [[ "$wifi_state" == "disabled" ]]; then
    echo "󰖪 OFF"
elif [[ "$connected" != "connected" ]]; then
    echo "󰖩 NO NET"
elif [[ $has_internet -ne 0 ]]; then
    echo "󰖟 LIMITED"
else
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
    echo "󰖩 $ssid"
fi
