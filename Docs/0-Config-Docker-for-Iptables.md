# Configuração do Docker com Iptables

Este guia fornece instruções detalhadas para configurar o Docker para usar o arquivo `daemon.json` e garantir que as configurações do iptables sejam aplicadas corretamente.

## Índice

1. [Configuração do daemon.json](#configuração-do-daemonjson)
2. [Configuração do Docker no Arch Linux](#configuração-do-docker-no-arch-linux)
3. [Carregar módulo br_netfilter](#carregar-módulo-br_netfilter)
4. [Configuração persistente do daemon.json](#configuração-persistente-do-daemonjson)
5. [Configuração do UFW](#configuração-do-ufw)

## Carregar módulo br_netfilter

Parece que o módulo `br_netfilter` não está carregado. Vamos carregá-lo e tentar novamente.

1. Carregue o módulo `br_netfilter`:

```sh
sudo modprobe br_netfilter
```

2. Verifique se o módulo foi carregado corretamente:

```sh
lsmod | grep br_netfilter
```

3. Habilite as opções `bridge-nf-call-iptables` e `bridge-nf-call-ip6tables`:

```sh
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
```

4. Para tornar essas configurações persistentes, adicione-as ao arquivo `/etc/sysctl.d/99-sysctl.conf`:

```sh
echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.d/99-sysctl.conf
echo "net.bridge.bridge-nf-call-ip6tables=1" | sudo tee -a /etc/sysctl.d/99-sysctl.conf
```

5. Reinicie o serviço do Docker:

```sh
sudo systemctl restart docker
```

6. Verifique novamente as configurações do Docker:

```sh
docker info
```

## Configuração do daemon.json

Crie ou edite o arquivo `daemon.json` no diretório docker:

```sh
sudo nano /etc/docker/daemon.json
```

3. Verifique se o conteúdo do arquivo `daemon.json` está correto e bem formatado:

   ```json
   {
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "10m",
       "max-file": "3"
     },
     "iptables": true, // Mudar para false caso nao queira intervenção do docker automatico sobre as regras do containerno iptables
     "storage-driver": "overlay2"
   }
   ```

Para garantir que o Docker leia e aplique as configurações do arquivo `daemon.json`, siga os passos abaixo:

1. Verifique se o arquivo `daemon.json` está no local correto:

```sh
sudo ls /etc/docker/daemon.json
```

2. Certifique-se de que o serviço do Docker foi reiniciado após a criação ou modificação do arquivo `daemon.json`:

```sh
sudo systemctl restart docker
```

4. Verifique se o Docker está usando as configurações do `daemon.json`:

```sh
docker info
```

5. Se as configurações ainda não estiverem sendo aplicadas, verifique os logs do Docker para possíveis erros:

```sh
sudo journalctl -u docker.service
```

Certifique-se de que não há erros nos logs que possam indicar problemas na leitura do arquivo `daemon.json`.

## Configuração do Docker no Arch Linux

No Arch Linux, a configuração do Docker pode ser feita no arquivo `daemon.json`. No entanto, se isso não estiver funcionando, você pode tentar configurar o Docker diretamente no arquivo de serviço do systemd.

1. Edite o arquivo de serviço do Docker:

```sh
sudo systemctl edit docker.service
```

2. Adicione as seguintes linhas para configurar o Docker a usar o arquivo `daemon.json`:

```ini
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --config-file /etc/docker/daemon.json
```

3. Salve e feche o editor.

4. Reinicie o serviço do Docker para aplicar as novas configurações:

```sh
sudo systemctl daemon-reload
sudo systemctl restart docker
```

5. Verifique se as configurações foram aplicadas:

```sh
docker info
```

## Configuração persistente do daemon.json

Para garantir que o Docker leia o arquivo `daemon.json` sem perder as configurações após o `daemon-reload`, siga os passos abaixo:

1. Crie ou edite o arquivo `daemon.json`:

   ```sh
   sudo nano /etc/docker/daemon.json
   ```

2. Adicione as configurações desejadas no arquivo `daemon.json`. Por exemplo:

```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "iptables": true,
  "storage-driver": "overlay2",
  "default-address-pools": [
    {
      "base": "172.17.0.0/16",
      "size": 16
    }
  ]
}
```

```bash
sudo systemctl restart docker
```

3. Crie um arquivo de configuração de substituição para o serviço Docker:

```sh
sudo mkdir -p /etc/systemd/system/docker.service.d
sudo nano /etc/systemd/system/docker.service.d/override.conf
```

4. Adicione as seguintes linhas ao arquivo `override.conf`:

```ini
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --config-file /etc/docker/daemon.json
```

5. Recarregue as configurações do systemd:

```sh
sudo systemctl daemon-reload
```

6. Reinicie o serviço do Docker:

```sh
sudo systemctl restart docker
```

7. Verifique novamente as configurações do Docker:

```sh
docker info
```

## Configuração do UFW

Para garantir que o UFW trabalhe junto com iptables, siga os passos abaixo:

```sh
sudo ufw enable
systemctl enable ufw
systemctl status ufw
```

```bash
sudo sh -c 'iptables-save > /etc/iptables/iptables.rules'
sudo sh -c 'ip6tables-save > /etc/iptables/ip6tables.rules'
```

## Solução de Problemas

Se o serviço do Docker falhar ao iniciar, siga os passos abaixo para solucionar o problema:

1. Verifique o status do serviço Docker:

```sh
sudo systemctl status docker
```

2. Verifique os logs do Docker para possíveis erros:

```sh
sudo journalctl -u docker.service
```

3. Verifique se há erros de configuração no arquivo `daemon.json`:

```sh
sudo cat /etc/docker/daemon.json
```

4. Tente reiniciar o serviço do Docker:

```sh
sudo systemctl restart docker
```

5. Se o problema persistir, verifique se há conflitos com outras regras de firewall ou serviços que possam estar interferindo no Docker.
