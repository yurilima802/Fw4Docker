#!/bin/bash

get_private_network() {
  local data_dir="$PWD/data/default_config"
  local private_ipv4="$data_dir/private_ipv4.txt"
  local private_ipv6="$data_dir/private_ipv6.txt"

  mkdir -p "$data_dir" || { echo "Erro ao criar diretório $data_dir"; exit 1; }
  
  echo "Buscando interfaces..."
  ## Padrao funcional
  #interfaces=$(ip link show | grep -oE 'eth[0-9]+|enp[0-9]+s[0-9]+')
  ## Regex teste all distribuitions
  interfaces=$(ip link show | awk -F': ' '{print $2}' | grep -E '^(eth|enp|wlan|ens|br|bond|veth|docker|virbr)[0-9a-zA-Z]+')

  if [ -n "$interfaces" ]; then
    echo "Interfaces encontradas: $interfaces"
    > "$private_ipv4"
    > "$private_ipv6"

    for interface in $interfaces; do
      ipv4=$(ip a show "$interface" | grep "inet " | awk '{print $2}')
      ipv6=$(ip a show "$interface" | grep "inet6 " | awk '{print $2}')
      
      if [ -n "$ipv4" ]; then
        echo "$ipv4" >> "$private_ipv4"
      fi
      if [ -n "$ipv6" ]; then
        echo "$ipv6" >> "$private_ipv6"
      fi
    done
    echo "IPs privados salvos em: $private_ipv4 e $private_ipv6"
  else
    echo "Nenhuma interface válida encontrada."
    exit 1
  fi
}

get_private_network
