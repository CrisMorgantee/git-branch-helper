#!/usr/bin/env bats

# Teste se a função principal exibe ajuda com a opção -h
@test "Display help with -h option" {
  run ./bin/git-brancher -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Usage: git-brancher" ]]
}

# Teste se o script detecta a ausência do Git
@test "Error when Git is not installed" {
  skip "Requires isolated environment without Git"
  run ./bin/git-brancher
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Git is not installed" ]]
}

# Teste de alternância de branch inválida
@test "Switch to a non-existing branch" {
  run ./bin/git-brancher non_existing_branch
  [ "$status" -ne 0 ]
  [[ "$output" =~ "Branch 'non_existing_branch' not found" ]]
}

# Teste de limpeza de cache
@test "Clear branch cache" {
  touch "$HOME/.cache/gkb/branch"
  run ./bin/git-brancher -C
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Branch cache cleared" ]]
  [ ! -f "$HOME/.cache/gkb/branch" ]
}

# Teste para alternar para a última branch
@test "Switch to last branch" {
  run ./bin/git-brancher
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Switching to the last branch" ]]
}

# Teste de remoção de branches órfãs
@test "Prune orphan branches" {
  run ./bin/git-brancher -p
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Branches locais órfãs removidas" ]]
}