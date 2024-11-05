#!/usr/bin/env bash
# lib/git_utils.sh

# Verificar pré-requisitos (Git instalado e repositório correto)
check_prerequisites() {
  if ! command -v git &>/dev/null; then
    echo "Error: Git is not installed. Please install Git to use git-brancher."
    return 1
  fi

  if [ ! -d ".git" ]; then
    echo "Error: Current directory is not a Git repository."
    return 1
  fi
  return 0
}

# Lógica principal para alternar branches e sincronizar
main_logic() {
  local branch="$1"

  # === Verificar Acessibilidade do Repositório Remoto =======================
  if ! git ls-remote "$remote" &>/dev/null; then
    echo "Erro: Não foi possível acessar o repositório remoto '$remote'. Verifique sua conexão de rede ou se o repositório remoto está configurado corretamente."
    return 1
  fi

  # === Fetch Atualizações ===================================================
  fetch_updates

  # === Podar Branches Locais se Solicitado ==================================
  $prune && prune_orphan_branches

  # === Definir o Nome da Branch =============================================
  branch=$(determine_branch "$branch") || return 1

  # === Verificar Mudanças Não Comittadas ====================================
  check_uncommitted_changes || return 1

  # === Verificar se a Branch Existe Remotamente =============================
  check_branch_exists_remotely "$branch" || return 1

  # === Alternar para a Branch ===============================================
  switch_branch "$branch"
}

# Determinar a última branch remota criada ou usar a fornecida
determine_branch() {
  local branch="$1"
  if [[ -n "$branch" ]]; then
    echo "$branch"
  else
    if [[ -f "$cache_file" && "$(find "$cache_file" -mmin -"$cache_duration")" ]]; then
      cat "$cache_file"
    else
      local user_name
      user_name=$(git config user.name)
      branch=$(git for-each-ref --sort=-committerdate --format='%(refname:short) %(authorname)' refs/remotes/"$remote" |
        grep -Ev "$remote/($exclude_branches)" | grep "$user_name" | awk '{print $1}' | head -n 1)

      if [[ -n "$branch" ]]; then
        echo "$branch" >"$cache_file"
      else
        echo "Erro: Não foi possível determinar a última branch remota criada."
        return 1
      fi
    fi
    echo "$branch"
  fi
}

# Buscar atualizações do repositório
fetch_updates() {
  if $fetch_all; then
    if ! git fetch --all; then
      echo "Erro: Falha ao buscar atualizações de todos os remotos."
      return 1
    fi
  else
    if ! git fetch "$remote"; then
      echo "Erro: Falha ao buscar atualizações do remoto '$remote'."
      return 1
    fi
  fi
}

# Podar branches órfãs
prune_orphan_branches() {
  if git remote prune "$remote"; then
    echo "Branches locais órfãs removidas."
  else
    echo "Erro: Falha ao podar branches órfãs do remoto '$remote'."
    return 1
  fi
}

# Verificar mudanças não comittadas
check_uncommitted_changes() {
  if ! git diff-index --quiet HEAD --; then
    echo "Aviso: Você tem alterações não comitadas."
    while true; do
      read -rp "Alternar de branch pode resultar em perda de dados. Deseja continuar? (y/n): " proceed
      case $proceed in
      [Yy]*) break ;;
      [Nn]*)
        echo "Operação cancelada."
        return 1
        ;;
      *) echo "Por favor, responda 'y' ou 'n'." ;;
      esac
    done
  fi
  return 0
}

# Verificar se a branch existe remotamente
check_branch_exists_remotely() {
  local branch="$1"
  local remote_branch="${remote}/${branch}"

  # Verificar a existência da branch remota
  if ! git ls-remote --heads "$remote" "$branch" &>/dev/null; then
    while true; do
      read -rp "Branch '$branch' não existe remotamente. Deseja criá-la localmente? (y/n): " confirm
      case $confirm in
      [Yy]*) break ;;
      [Nn]*)
        echo "Criação da branch cancelada."
        return 1
        ;;
      *) echo "Por favor, responda 'y' ou 'n'." ;;
      esac
    done
  fi
  return 0
}

# Alternar para a branch especificada
switch_branch() {
  local branch="$1"
  branch="${branch#"$remote/"}" # Remover o prefixo remoto

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    if ! git checkout "$branch"; then
      echo "Erro: Falha ao fazer checkout da branch '$branch'."
      return 1
    fi
    $sync && {
      if ! git pull "$remote" "$branch"; then
        echo "Erro: Falha ao atualizar a branch '$branch' a partir do remoto."
        return 1
      fi
    }
    echo "Alternado para a branch local '$branch' (atualizada)."
  else
    if git checkout -b "$branch" "$remote/$branch" 2>/dev/null; then
      echo "Alternado para a nova branch '$branch' criada a partir do remoto."
    else
      if git checkout -b "$branch"; then
        echo "Branch '$branch' não existe remotamente. Criada nova branch local '$branch'."
      else
        echo "Erro: Falha ao criar a nova branch '$branch'."
        return 1
      fi
    fi
  fi
}