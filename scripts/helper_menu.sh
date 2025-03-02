#!/bin/bash
# Menu de ajuda para os scripts de iptables

# Carregar as cores
source "./scripts/color_config.sh"

clear
echo -e "${CYAN}########################### ${GREEN}Menu de Ajuda${CYAN} ###########################${NC}"
echo ""
echo -e "${YELLOW}Este script ajuda na configuração do iptables para permitir ou bloquear tráfego de IPs específicos.${NC}"
echo ""
echo -e "${CYAN}Comandos disponíveis:${NC}"
echo "---------------------------------------------------------------"
echo -e "${GREEN}1)${NC} ${BOLD}-c <nome_da_lista> <ip>${NC}   --> Cria uma nova lista e adiciona o IP ao iptables."
echo -e "${CYAN}    Cria uma lista com o nome especificado e adiciona o IP ao iptables.${NC}"
echo ""
echo -e "${GREEN}2)${NC} ${BOLD}-r${NC}                        --> Executa a redefinição de configurações."
echo -e "${CYAN}    Executa o script de redefinição para restaurar as configurações iniciais.${NC}"
echo ""
echo -e "${GREEN}3)${NC} ${BOLD}-h${NC}                        --> Exibe este menu de ajuda."
echo -e "${CYAN}    Exibe este menu de ajuda, fornecendo informações sobre os comandos.${NC}"
echo ""
echo -e "${CYAN}Exemplos de uso:${NC}"
echo "---------------------------------------------------------------"
echo -e "${GREEN}1)${NC} Para criar uma lista e adicionar um IP ao iptables:"
echo -e "$0 ${BOLD}-c minha_lista 192.168.0.1${NC}"
echo -e "${CYAN}    Este comando cria uma lista chamada 'minha_lista' e adiciona o IP 192.168.0.1 ao iptables.${NC}"
echo -e "${CYAN}    As regras do iptables serão aplicadas para permitir apenas tráfego nas portas 80 (HTTP) e 443 (HTTPS).${NC}"
echo ""
echo -e "${GREEN}2)${NC} Para redefinir as configurações do iptables e restaurar as regras padrão:"
echo -e "$0 ${BOLD}-r${NC}"
echo -e "${CYAN}    Este comando executa o script de redefinição, restaurando as configurações iniciais do sistema.${NC}"
echo ""
echo -e "${CYAN}Para saber mais sobre cada comando, consulte o código-fonte dos scripts mencionados ou entre em contato com o administrador.${NC}"
echo ""
echo -e "${RED}Pressione [Enter] para sair.${NC}"
read -r
exit 0