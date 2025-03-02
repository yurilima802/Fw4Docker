#!/bin/bash

get_router_network() {
  local data_dir="$PWD/data/default_config"
  local gateway_ip="$data_dir/gateway_ip.txt"

  mkdir -p "$data_dir" || { echo "Erro ao criar diretório $data_dir"; exit 1; }

  gateway=$(ip route | grep "default" | awk '{print $3}')

  if [ -n "$gateway" ]; then
    echo "Gateway padrão: $gateway"
    echo "$gateway" > "$gateway_ip" || { echo "Erro ao salvar gateway em $gateway_ip"; exit 1; }
  else
    echo "Nenhum gateway padrão encontrado."
    exit 1
  fi
}

get_router_network
