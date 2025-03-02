#!/bin/bash

get_public_repositorys_ip4() {
    local data_dir="$PWD/data/default_config"
    local repository_ip4_dir="$data_dir/repositorys_ip4.txt"

    # Verifica se o diretório existe
    if [ ! -d "$data_dir" ]; then
        echo "Diretório $data_dir não existe. Criando..."
        mkdir -p "$data_dir"
    fi

    repos=(
        # Debian e derivados
        "deb.debian.org"
        "security.debian.org"
        "archive.ubuntu.com"
        "security.ubuntu.com"

        # Arch Linux
        "mirror.rackspace.com"
        "archlinux.mirror.digitalpacific.com.au"
        "mirror.archlinux.org"
        "aur.archlinux.org"

        # Fedora
        "download.fedoraproject.org"

        # CentOS / RHEL
        "mirror.centos.org"

        # Docker
        "download.docker.com"
        "hub.docker.com"

        # NPM
        "registry.npmjs.org"

        # Python
        "pypi.org"
        "files.pythonhosted.org"

        # Rust
        "static.rust-lang.org"
        "crates.io"

        # Flutter
        "storage.googleapis.com"
        "flutter.dev"

        # Dart
        "dart.dev"
        "pub.dev"

        # Conda
        "repo.anaconda.com"           # Repositórios Conda

        # Bun
        "bun.sh"                       # Repositórios Bun

        # Git
        "git-scm.com"                  # Repositório Git (site oficial)

        # GitHub
        "github.com"                   # GitHub (não é um repositório de pacotes, mas relevante)
        "api.github.com"               # API GitHub

        # Homebrew
        "brew.sh"                       # Repositórios Homebrew

        # Composer (PHP)
        "repo.packagist.org"           # Repositórios Composer (PHP)

        # RubyGems
        "rubygems.org"                 # Repositórios RubyGems

        # Maven (Java)
        "repo.maven.apache.org"        # Repositórios Maven

        # Go (Golang)
        "proxy.golang.org"             # Repositório Go

        # Swift
        "swift.org"                    # Repositório Swift

        # .NET (NuGet)
        "nuget.org"                    # Repositório NuGet (C#, .NET)

        # Perl
        "cpan.org"                     # Repositório CPAN (Perl)

        # Red Hat / EPEL
        "mirror.openshift.com"
        "mirror.centos.org"

        # Arch Linux (Pacman)
        "archlinux.org"

        # Mais repositórios populares
        "packages.microsoft.com"
        "download.virtualbox.org"
        "repo.mysql.com"
        "packages.cloud.google.com"
        "packagecloud.io"
        "packages.gitlab.com"
        "dl.yarnpkg.com"

        # NVIDIA
        "download.nvidia.com"
        "developer.nvidia.com"

        # AMD
        "support.amd.com"
        "cdn.amd.com"

        # Outros repositórios de drivers e hardware
        "packages.kernel.org"
        "repo.radeon.com"
    )

    # Resolver IPs dos repositórios e armazenar em um array
    ips=()
    for repo in "${repos[@]}"; do
        # Resolver IP e adicionar ao array
        result=$(nslookup "$repo" 2>/dev/null | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}')
        if [ -n "$result" ]; then
            ips+=("$result")
        else
            echo "Falha ao resolver o DNS para $repo"
        fi
    done

    # Remover IPs duplicados e salvar em um arquivo
    if [ ${#ips[@]} -gt 0 ]; then
        # Salva os IPs únicos no arquivo
        echo "${ips[@]}" | tr ' ' '\n' | sort -u > "$repository_ip4_dir"
        echo "IPs únicos foram salvos no arquivo $repository_ip4_dir"
    else
        echo "Nenhum IP válido foi resolvido. Nenhum arquivo foi gerado."
    fi
    
}

# Chama a função
get_public_repositorys_ip4