#!/bin/bash

# Função para criar uma lista única de IPs a partir de arquivos na pasta client_config
create_unique_ip_list() {
  local data_dir="$PWD/data/client_config"   # Diretório onde os arquivos de configuração estão localizados
  local output_file="$data_dir/default_client.txt"  # Arquivo de saída onde a lista única de IPs será salva
  
  # Cria o diretório de saída, caso não exista
  mkdir -p "$data_dir" || { echo "Erro ao criar diretório $data_dir"; exit 1; }

  # Limpa o arquivo de saída se ele já existir
  > "$output_file"

  # Variável para armazenar todos os IPs
  declare -A ip_list

  # Percorre todos os arquivos dentro do diretório client_config
  for file in "$data_dir"/*; do
    if [ -f "$file" ]; then
      echo "Lendo o arquivo: $file"

      # Lê cada linha do arquivo
      while IFS= read -r ip; do
        if [ -n "$ip" ]; then
          # Verifica se o IP ainda não foi adicionado (evitar duplicatas)
          if [[ -z "${ip_list[$ip]}" ]]; then
            ip_list["$ip"]=1  # Marca o IP como já adicionado
            echo "$ip" >> "$output_file"  # Adiciona o IP ao arquivo de saída
          fi
        fi
      done < "$file"
    fi
  done

  echo "Lista de IPs única criada com sucesso em: $output_file"

  # Adiciona as regras no iptables para todos os IPs únicos encontrados
  while IFS= read -r ip; do
    if [ -n "$ip" ]; then
      echo "Adicionando regra iptables para o IP: $ip"
      sudo iptables -A INPUT -s "$ip" -j ACCEPT || { echo "Erro ao adicionar regra para $ip"; exit 1; }
    fi
  done < "$output_file"

  echo "Regras iptables foram adicionadas com sucesso."
}

# Chama a função para criar a lista única de IPs e adicionar as regras no iptables
create_unique_ip_list
