#!/bin/bash

get_public_services() {
  local data_dir="$PWD/data/default_config"
  local cloudflare_ipv4_ul="https://www.cloudflare.com/ips-v4"
  local cloudflare_ipv6_ul="https://www.cloudflare.com/ips-v6"
  local get_public_ip_url="https://ifconfig.me"

  mkdir -p "$data_dir" || { echo "Erro ao criar diretório $data_dir"; exit 1; }
  
  # Baixar os IPs públicos do Cloudflare
  curl -s "$cloudflare_ipv4_ul" -o "$data_dir/cloudflare_ipv4.txt" || { echo "Erro ao obter IPs do Cloudflare IPv4"; exit 1; }
  curl -s "$cloudflare_ipv6_ul" -o "$data_dir/cloudflare_ipv6.txt" || { echo "Erro ao obter IPs do Cloudflare IPv6"; exit 1; }

  # Obter o IP público atual
  curl -s "$get_public_ip_url" | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}|([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}' > "$data_dir/public_ip.txt" || { echo "Erro ao obter IP público"; exit 1; }

  echo "Arquivos salvos em $data_dir"
}

get_public_services
