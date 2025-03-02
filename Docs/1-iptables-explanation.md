No `iptables`, a regra principal para as demais regras de encaminhamento (forwarding) é chamada de "chain" (cadeia). As cadeias principais são `INPUT`, `FORWARD`, e `OUTPUT`.

- `chain` (cadeia): Conjunto de regras que define como os pacotes devem ser tratados.
  - `INPUT`: Regras para pacotes destinados ao sistema local.
    - Exemplo de regra: `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`
    - Exemplo de regra: `iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`
  - `FORWARD`: Regras para pacotes que passam pelo sistema, mas não são destinados a ele.
    - Exemplo de regra: `iptables -A FORWARD -p tcp --dport 80 -j ACCEPT`
    - Exemplo de regra: `iptables -A FORWARD -s 192.168.1.0/24 -d 192.168.2.0/24 -j ACCEPT`
  - `OUTPUT`: Regras para pacotes originados do sistema local.
    - Exemplo de regra: `iptables -A OUTPUT -p udp --dport 53 -j ACCEPT`
    - Exemplo de regra: `iptables -A OUTPUT -m state --state NEW,ESTABLISHED -j ACCEPT`
  - `PREROUTING`: Regras que são aplicadas antes do roteamento dos pacotes.
    - Exemplo de regra: `iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.100:80`
  - `POSTROUTING`: Regras que são aplicadas após o roteamento dos pacotes.
    - Exemplo de regra: `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`

Para criar regras de encaminhamento, você geralmente adiciona regras à cadeia `FORWARD`.

```bash
# Flush all rules and set default policies

sudo iptables -F
sudo iptables -X
sudo iptables -Z
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT


# Limpar todas as regras
sudo iptables -F
# Limpar todas as regras de NAT
sudo iptables -t nat -F
# Limpar todas as regras de mangle
sudo iptables -t mangle -F
# Excluir todas as cadeias personalizadas
sudo iptables -X
# Resetar as contagens de pacotes e bytes
sudo iptables -Z

# Permitir conexões estabelecidas e relacionadas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir localhost
iptables -A INPUT -i lo -j ACCEPT

# Permitir SSH (opcional)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow local network

sudo iptables -A INPUT -s 192.168.0.234/24 -j ACCEPT
sudo iptables -A INPUT -s 192.168.0.0/24 -j ACCEPT
sudo iptables -A INPUT -s 192.168.0.1/24 -j ACCEPT
sudo iptables -A INPUT -s 173.245.48.0/20 -j ACCEPT
sudo iptables -A INPUT -s 103.21.244.0/22 -j ACCEPT
sudo iptables -A INPUT -s 103.22.200.0/22 -j ACCEPT
sudo iptables -A INPUT -s 103.31.4.0/22 -j ACCEPT
sudo iptables -A INPUT -s 141.101.64.0/18 -j ACCEPT
sudo iptables -A INPUT -s 108.162.192.0/18 -j ACCEPT
sudo iptables -A INPUT -s 190.93.240.0/20 -j ACCEPT
sudo iptables -A INPUT -s 188.114.96.0/20 -j ACCEPT
sudo iptables -A INPUT -s 197.234.240.0/22 -j ACCEPT
sudo iptables -A INPUT -s 198.41.128.0/17 -j ACCEPT
sudo iptables -A INPUT -s 162.158.0.0/15 -j ACCEPT
sudo iptables -A INPUT -s 104.16.0.0/13 -j ACCEPT
sudo iptables -A INPUT -s 104.24.0.0/14 -j ACCEPT
sudo iptables -A INPUT -s 172.64.0.0/13 -j ACCEPT
sudo iptables -A INPUT -s 131.0.72.0/22 -j ACCEPT
# Save rules

sudo sh -c 'iptables-save > /etc/iptables/iptables.rules'

# Usando iptables-restore
iptables-restore < /etc/iptables/iptables.rules

# Restart iptables
sudo systemctl restart iptables

# Verify update rules

sudo iptables -L

sudo systemctl restart docker

```
