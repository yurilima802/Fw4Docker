## **`Docker Protected`**

# Permitir apenas ips da cloudflare, ip local, e my_ip_public

```bash
# Limpar regras existentes na cadeia DOCKER-USER

sudo iptables -F DOCKER-USER

# Permitir tráfego da localhost

sudo iptables -A DOCKER-USER -s 127.0.0.1/32 -j ACCEPT

# Permitir tráfego da rede 192.168.0.0/24

sudo iptables -A DOCKER-USER -s 192.168.0.0/24 -j ACCEPT

# Permitir tráfego do IP específico 192.168.0.234

sudo iptables -A DOCKER-USER -s 192.168.0.234 -j ACCEPT

sudo iptables -A DOCKER-USER -s 173.245.48.0/20 -j ACCEPT

sudo iptables -A DOCKER-USER -s 103.21.244.0/22 -j ACCEPT

sudo iptables -A DOCKER-USER -s 103.22.200.0/22 -j ACCEPT

sudo iptables -A DOCKER-USER -s 103.31.4.0/22 -j ACCEPT

sudo iptables -A DOCKER-USER -s 141.101.64.0/18 -j ACCEPT

sudo iptables -A DOCKER-USER -s 108.162.192.0/18 -j ACCEPT

sudo iptables -A DOCKER-USER -s 190.93.240.0/20 -j ACCEPT

sudo iptables -A DOCKER-USER -s 188.114.96.0/20 -j ACCEPT

sudo iptables -A DOCKER-USER -s 197.234.240.0/22 -j ACCEPT

sudo iptables -A DOCKER-USER -s 198.41.128.0/17 -j ACCEPT

sudo iptables -A DOCKER-USER -s 162.158.0.0/15 -j ACCEPT

sudo iptables -A DOCKER-USER -s 104.16.0.0/13 -j ACCEPT

sudo iptables -A DOCKER-USER -s 104.24.0.0/14 -j ACCEPT

sudo iptables -A DOCKER-USER -s 172.64.0.0/13 -j ACCEPT

sudo iptables -A DOCKER-USER -s 131.0.72.0/22 -j ACCEPT

# Permitir conexões estabelecidas e relacionadas

sudo iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Bloquear todo o restante do tráfego

sudo iptables -A DOCKER-USER -j DROP

```

## **`Explanation`**

# Permitir conexões estabelecidas e relacionadas

```bash
sudo iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Esta regra é crucial para manter a comunicação bidirecional funcionando:
#
# - '--ctstate RELATED,ESTABLISHED': Verifica o estado da conexão
#   - ESTABLISHED: Permite pacotes que fazem parte de uma conexão já estabelecida
#   - RELATED: Permite conexões que estão relacionadas a uma conexão existente
#     (como conexões FTP de dados ou respostas ICMP)
#
# - '-j ACCEPT': Se o pacote corresponder aos estados acima, ele será aceito
#
# Esta regra é importante porque permite que as conexões existentes continuem
# funcionando, mesmo quando outras regras mais restritivas são aplicadas.
```
