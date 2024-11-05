#!/usr/bin/env bash
# lib/config.sh

# Definir valores padrão antes de carregar qualquer arquivo de configuração
remote="origin"                        # Repositório remoto padrão
cache_duration=30                      # Duração padrão do cache em minutos
exclude_branches="main|master|develop" # Branches a serem excluídas da busca por padrão

# Função para carregar o arquivo de configuração do usuário, se houver
load_config() {
  local config_file="$HOME/.gkb_config"

  # Verificar se o arquivo de configuração existe
  if [ -f "$config_file" ]; then
    # Carregar o arquivo de configuração
    source "$config_file"
  fi

  # Garantir que valores padrão sejam atribuídos se não definidos no arquivo de configuração
  : "${cache_duration:=30}"
  : "${remote:=origin}"
  : "${exclude_branches:=main|master|develop}"
}