# Projeto de Configuração de iptables via Shell

Este projeto tem como objetivo configurar as regras do `iptables` através de scripts em shell, permitindo a liberação controlada de tráfego de rede com base em várias fontes e necessidades. Abaixo estão as funcionalidades principais e instruções para uso do script.

## Funcionalidades

- **Restaurar Regras do iptables**: O script restaura as regras do `iptables` a partir de arquivos previamente salvos, garantindo que a configuração de segurança seja aplicada corretamente.
- **Baixar IPs da Cloudflare**: O script baixa automaticamente os endereços IPs públicos utilizados pela Cloudflare, que podem ser liberados no firewall.
- **Baixar IPs Públicos**: O script também faz o download de IPs públicos que podem ser utilizados para configuração de acesso.
- **Verificar IPs Privados**: O script verifica a rede interna (privada) e permite a configuração de regras para os IPs dessa rede.
- **Adicionar Regras para Clientes**: É possível liberar o acesso de IPs específicos a portas como 80 (HTTP), 443 (HTTPS), 8010 e 4443 (para serviços do Gitness). A liberação de acesso é feita por parâmetros passados na execução do script.

### Comando para adicionar um novo cliente:
```bash
./main.sh -c "novo cliente" "ip.cliente"
```

- **`-c`**: Adiciona uma nova configuração de cliente.
- **`"novo cliente"`**: Nome ou identificação do cliente.
- **`"ip.cliente"`**: O IP do cliente que deve ter acesso liberado.

### Comando para exibir o menu de ajuda:
```bash
./main.sh -h
```

- **`-h`**: Exibe o menu de ajuda com informações sobre como usar o script.

### Configuração de Repositórios Públicos:
O script também configura regras para permitir o acesso aos repositórios públicos Linux, como repositórios de pacotes e linguagens. Estes repositórios são essenciais para o gerenciamento de pacotes e dependências de software.

### Configuração do Sistema:
O script aplica regras para garantir que o sistema Linux receba as configurações de firewall mencionadas anteriormente.

### Configuração do Docker:
O Docker também é configurado para permitir a aplicação das regras de `iptables` nas redes de containers, garantindo que as configurações de acesso sejam corretamente propagadas para os containers em execução.

## Como Usar

1. **Clone o repositório:**
   Para usar o script, primeiro clone o repositório ou baixe o código.

2. **Execute o Script:**

   Para adicionar um cliente e liberar o acesso, use o comando:
   ```bash
   ./main.sh -c "nome_cliente" "ip_cliente"
   ```

   Para exibir a ajuda e entender os parâmetros disponíveis, use:
   ```bash
   ./main.sh -h
   ```

3. **Repositórios Públicos:**

   O script configura automaticamente os repositórios públicos Linux, como repositórios de pacotes de distribuição e repositórios de linguagens de programação.

4. **Configuração do Sistema e Docker:**

   O script aplica as configurações do `iptables` para garantir que o sistema receba as permissões de tráfego necessárias. Além disso, o Docker é configurado para aplicar as regras de firewall de maneira apropriada.

## Estrutura dos Arquivos

- **main.sh**: Script principal para execução das configurações e parâmetros.
- **helper_menu.sh**: Script com menu de ajuda, fornecendo orientações para uso.
- **scripts/**: Diretório contendo scripts auxiliares para realizar as operações de configuração.
- **data/**: Diretório com arquivos de configuração e dados necessários para aplicar as regras.

## Requisitos

- **Linux**: O script foi projetado para sistemas baseados em Linux.
- **Permissões de root**: O script requer permissões de administrador para modificar as regras do `iptables` e configurar o sistema.
- **Docker**: O Docker precisa estar instalado se você deseja configurar regras para containers.

## Contribuição

Sinta-se à vontade para contribuir com melhorias ou sugestões. Para contribuir:

1. Faça um fork deste repositório.
2. Crie uma branch para a sua modificação (`git checkout -b minha-modificacao`).
3. Faça suas alterações e commit.
4. Envie um pull request com uma descrição clara do que foi alterado.

## Licença

Este projeto está licenciado sob a [Licença MIT](LICENSE).