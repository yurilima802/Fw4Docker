#!/bin/bash

# Função para adicionar IP à lista e iptables
create_list_allow_iptables() {
  local name="$1"   # Nome do arquivo
  local ip="$2"     # IP a ser adicionado
  
  # Diretório onde o arquivo será salvo
  local data_dir="$PWD/data/client_config"
  local new_list="$data_dir/$name.txt"

  # Cria o diretório, caso não exista
  mkdir -p "$data_dir" || { echo "Erro ao criar diretório $data_dir"; exit 1; }

  # Verifica se o IP foi fornecido
  if [ -z "$ip" ]; then
    echo "Erro: Nenhum IP foi fornecido."
    exit 1
  fi

  # Verificação de IP válido usando regex
  if ! [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Erro: O IP fornecido não é válido."
    exit 1
  fi

  # Verifica se cada parte do IP está entre 0 e 255
  IFS='.' read -r -a octets <<< "$ip"
  for octet in "${octets[@]}"; do
    if [ "$octet" -lt 0 ] || [ "$octet" -gt 255 ]; then
      echo "Erro: O IP fornecido contém valores inválidos (cada octeto deve estar entre 0 e 255)."
      exit 1
    fi
  done

  # Adiciona o IP no arquivo
  echo "$ip" >> "$new_list" || { echo "Erro ao adicionar IP ao arquivo $new_list"; exit 1; }

  # Adiciona a regra no iptables
  echo "Adicionando regra iptables para o IP: $ip"
  sudo iptables -A INPUT -s "$ip" -j ACCEPT || { echo "Erro ao adicionar regra para $ip"; exit 1; }

  echo "IP $ip adicionado ao arquivo $new_list e à configuração do iptables."
}
