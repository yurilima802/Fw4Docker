#!/bin/bash

flush_iptables() {
  echo "Flushing iptables..."
  sudo iptables -F || { echo "Erro ao limpar regras do iptables"; exit 1; }
  sudo iptables -X || { echo "Erro ao remover cadeias do iptables"; exit 1; }
  sudo iptables -Z || { echo "Erro ao zerar contadores do iptables"; exit 1; }
  sudo iptables -P INPUT DROP || { echo "Erro ao definir política INPUT"; exit 1; }
  sudo iptables -P FORWARD DROP || { echo "Erro ao definir política FORWARD"; exit 1; }
  sudo iptables -P OUTPUT ACCEPT || { echo "Erro ao definir política OUTPUT"; exit 1; }

  # Permitir conexões estabelecidas e relacionadas
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT || { echo "Erro ao permitir conexões estabelecidas"; exit 1; }
  iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT || { echo "Erro ao permitir conexões estabelecidas no FORWARD"; exit 1; }

  # Permitir localhost
  iptables -A INPUT -i lo -j ACCEPT || { echo "Erro ao permitir localhost"; exit 1; }

  # Permitir SSH (opcional)
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT || { echo "Erro ao permitir SSH"; exit 1; }

  echo "Regras do iptables limpas e configuradas com sucesso."
}

flush_iptables
