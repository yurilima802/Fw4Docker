#!/bin/bash

#################################### Configure iptables ###############################
#######################################################################################

# Solicita o uso de sudo antes de começar a manipular o iptables
if ! sudo -v; then
    sudo su
    echo "Este script precisa de privilégios administrativos (sudo)."
    exit 1
fi

# Carregar as cores
source "./scripts/color_config.sh"

# Defina o diretório de scripts
scripts_dir="$PWD/scripts"

#################################### Create New Cliente ###############################

# Função para exibir o menu de ajuda
show_help() {
    source "$scripts_dir/helper_menu.sh" # Carrega o arquivo de ajuda
}

# Função para redefinir (execute o script de redefinição)
reset_script() {
    echo -e "${CYAN}Executando o script de redefinição...${RESET}"
    source "reset_iptables.sh"
    # Adicione aqui a lógica para redefinir
    # Exemplo: source "$scripts_dir/reset_script.sh"
}

# Verificar se nenhum parâmetro foi passado
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

# Função para verificar os parâmetros e ações
while getopts "c:hr" opt; do
    case "$opt" in
    c) # Se o parâmetro '-c' for fornecido, cria a lista e adiciona o IP ao iptables
        name="$OPTARG"
        shift $((OPTIND - 1))
        ip="$1"

        if [ -z "$name" ] || [ -z "$ip" ]; then
            echo -e "${RED}Erro: Você deve fornecer um nome de lista e um IP após o parâmetro -c.${RESET}"
            exit 1
        fi

        # Chama a função para criar a lista de IPs
        source "$scripts_dir/create_new_client.sh"
        create_list_allow_iptables "$name" "$ip"
        ;;
    h) # Se o parâmetro '-h' for passado, exibe o menu de ajuda
        show_help
        ;;
    r) # Se o parâmetro '-r' for passado, executa o script de redefinição
        reset_script
        ;;
    *)
        echo -e "${RED}Uso: $0 -c <nome_da_lista> <ip> [-h] [-r]${RESET}"
        exit 1
        ;;
    esac
done

# # Se nenhum parâmetro for passado, o script não faz nada
# if [ $OPTIND -eq 1 ]; then
#     echo "Nenhum comando foi passado. O script não fará nenhuma ação."
#     exit 1
# fi

################################# Config Iptables Local ###############################

# Defina o diretório de dados
base_data_dir="$PWD/data"
# Logo
source "$scripts_dir/logo.sh"

# Chama os scripts geradores de Ips (esses scripts devem já ter criado os arquivos de IP)
source "$scripts_dir/flush_iptables.sh"
source "$scripts_dir/get_private_network.sh"
source "$scripts_dir/get_public_services.sh"
source "$scripts_dir/get_router_network.sh"
source "$scripts_dir/read_new_client.sh"
source "$scripts_dir/get_repository_ip4.sh"

# Diretorios dos arquivos de IPs
private_network_dir="$base_data_dir/default_config"
public_services_dir="$base_data_dir/default_config"
router_network_dir="$base_data_dir/default_config"
client_network_dir="$base_data_dir/client_config"
repository_network_dir="$base_data_dir/default_config"

#!/bin/bash

# Função para adicionar regras no iptables permitindo apenas portas 80 (HTTP) e 443 (HTTPS) para IPs de clientes
add_client_ports_80_443() {
    local file_path="$1"

    if [[ -f "$file_path" ]]; then
        while IFS= read -r ip; do
            if [[ -n "$ip" ]]; then
                # Adiciona regras para permitir o tráfego nas portas 80 (HTTP) e 443 (HTTPS)
                echo -e "${BLUE}Adicionando regras para o IP $ip para as portas 80 e 443${RESET}"
                # Permite acesso apenas nas portas 80 (HTTP) e 443 (HTTPS)
                sudo iptables -A INPUT -p tcp -s "$ip" --dport 80 -j ACCEPT || {
                    echo -e "${RED}Erro ao adicionar regra para a porta 80 no IP $ip${RESET}"
                    exit 1
                }
                #Gitness
                sudo iptables -A INPUT -p tcp -s "$ip" --dport 8010 -j ACCEPT || {
                    echo -e "${RED}Erro ao adicionar regra para a porta 8010 no IP $ip${RESET}"
                    exit 1
                }
                #Gitness Tls
                sudo iptables -A INPUT -p tcp -s "$ip" --dport 4443 -j ACCEPT || {
                    echo -e "${RED}Erro ao adicionar regra para a porta 4443 no IP $ip${RESET}"
                    exit 1
                }
                sudo iptables -A INPUT -p tcp -s "$ip" --dport 443 -j ACCEPT || {
                    echo -e "${RED}Erro ao adicionar regra para a porta 443 no IP $ip${RESET}"
                    exit 1
                }

            fi
        done <"$file_path"
    else
        echo "Arquivo $file_path não encontrado."
        exit 1
    fi
}

# Função para adicionar regras do iptables para IPs de arquivos
add_iptables_rules() {
    local file_path="$1"

    if [[ -f "$file_path" ]]; then
        while IFS= read -r ip; do
            if [[ -n "$ip" ]]; then
                echo -e "${CYAN}Adicionando regra iptables para o IP: $ip${RESET}"
                sudo iptables -A INPUT -s "$ip" -j ACCEPT || {
                    echo -e "${RED}Erro ao adicionar regra para $ip${RESET}"
                    exit 1
                }
            fi
        done <"$file_path"
    else
        echo -e "${RED}Arquivo $file_path não encontrado.${RESET}"
        exit 1
    fi
}

# Adiciona regras para os IPs de Clientes 
add_client_ports_80_443 "$client_network_dir/default_client.txt"
# Adiciona regras para os IPs de Repositórios 
add_iptables_rules "$repository_network_dir/repositorys_ip4.txt"
# Adiciona regras para os IPs privados
add_iptables_rules "$private_network_dir/private_ipv4.txt"
# Adiciona regras para os IPs públicos (de public_services)
add_iptables_rules "$public_services_dir/cloudflare_ipv4.txt"
add_iptables_rules "$public_services_dir/public_ip.txt"
# Adiciona regra para o IP do gateway (de router_network)
add_iptables_rules "$router_network_dir/gateway_ip.txt"

# Salva e aplica as regras
echo "Salvando regras iptables"
sudo sh -c 'iptables-save > /etc/iptables/iptables.rules'
echo "Restaurando regras iptables"
sudo iptables-restore </etc/iptables/iptables.rules
echo "Reiniciando iptables"
sudo systemctl restart iptables


echo "Reiniciando iptables"
sudo systemctl restart iptables
echo "Verificando regras iptables"
sudo iptables -L
echo "Reiniciando Docker para forçar a recriar a cadeia no iptables"
sudo systemctl restart docker

echo "Regras do iptables foram configuradas com sucesso."

################################# Config Iptables Docker ###############################

# Função para adicionar regras do iptables para IPs de arquivos
add_iptables_rules_on_docker() {
    local file_path="$1"

    if [[ -f "$file_path" ]]; then
        while IFS= read -r ip; do
            if [[ -n "$ip" ]]; then
                echo -e "${YELLOW}Limpar regras existentes na cadeia DOCKER-USER${RESET}"
                echo -e "${BLUE}Adicionando regra iptables para o IP: $ip${RESET}"
                sudo iptables -A DOCKER-USER -s "$ip" -j ACCEPT || {
                    echo -e "${RED}Erro ao adicionar regra para $ip${RESET}"
                    exit 1
                }
            fi
        done <"$file_path"
    else
        echo "Arquivo $file_path não encontrado."
        exit 1
    fi
}

sudo iptables -F DOCKER-USER
# Adiciona regras para os IPs privados (de private_network)
add_iptables_rules_on_docker "$private_network_dir/private_ipv4.txt"
# Adiciona regras para os IPs públicos (de public_services)
add_iptables_rules_on_docker "$public_services_dir/cloudflare_ipv4.txt"
add_iptables_rules_on_docker "$public_services_dir/public_ip.txt"
# Adiciona regra para o IP do gateway (de router_network)
add_iptables_rules_on_docker "$router_network_dir/gateway_ip.txt"
# Adiciona regra para o IP do Cliente (de router_network)
add_iptables_rules_on_docker "$client_network_dir/default_client.txt"
# Adiciona regras para os IPs de Repositórios 
add_iptables_rules_on_docker "$repository_network_dir/repositorys_ip4.txt"

sudo iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A DOCKER-USER -j DROP
sudo sh -c 'iptables-save > /etc/iptables/iptables.rules'
iptables-restore </etc/iptables/iptables.rules
sudo systemctl restart iptables
sudo iptables -L
sudo systemctl restart docker
