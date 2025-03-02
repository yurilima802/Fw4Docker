#!/bin/bash

# Nome do arquivo para salvar as regras do iptables (opcional)
IPTABLES_RULES_FILE="/etc/iptables/iptables.rules"

# Função para restaurar o iptables ao padrão de fábrica
restore_iptables_factory_defaults() {
  echo "Restaurando iptables para o padrão de fábrica..."

  # Flush all rules and set default policies
  sudo iptables -F
  sudo iptables -X
  sudo iptables -Z

  # Altera as políticas para aceitar tudo
  sudo iptables -P INPUT ACCEPT    # Altere para DROP se desejar bloquear tudo por padrão
  sudo iptables -P FORWARD ACCEPT  # Altere para DROP se desejar bloquear tudo por padrão
  sudo iptables -P OUTPUT ACCEPT

  echo "Iptables restaurado para o padrão de fábrica."
}

# Função para salvar as regras do iptables
save_iptables_rules() {
  echo "Salvando as regras do iptables..."
  sudo iptables-save > $IPTABLES_RULES_FILE
  echo "Regras do iptables salvas em $IPTABLES_RULES_FILE."
}

# Função para reiniciar o Docker
restart_docker() {
  echo "Reiniciando o Docker..."
  sudo systemctl restart docker
  echo "Docker reiniciado."
}

# Função principal
main() {
  echo "Iniciando script de restauração do iptables e reinício do Docker..."
  restore_iptables_factory_defaults
  restart_docker
  save_iptables_rules
  echo "Script concluído."
}

main
