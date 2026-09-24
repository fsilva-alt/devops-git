#!/usr/bin/env bash
# Biblioteca compartilhada pelos scripts do curso. Não execute este arquivo
# diretamente: ele é carregado (source) por setup.sh, check.sh, reset.sh e colega.sh.

set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSO_DIR="$(cd "$SCRIPTS_DIR/.." && pwd)"

# Onde os laboratórios ficam: ~/labs, fora do repositório do curso, para não
# aninhar diretórios .git. Pode ser sobrescrito com a variável LABS_DIR.
LABS_DIR="${LABS_DIR:-$HOME/labs}"
REMOTOS_DIR="$LABS_DIR/.remotos"

# Nome de cada desafio, indexado pelo número.
LAB_NOMES=(
  "configure-sua-identidade"
  "meu-primeiro-repositorio"
  "registrando-mudancas"
  "commit-cirurgico"
  "ignorando-o-que-nao-importa"
  "detetive-do-historico"
  "desfazendo-antes-do-commit"
  "desfazendo-depois-do-commit"
  "branch-de-funcionalidade"
  "caminhos-que-divergem"
  "guardando-para-depois"
  "resolva-o-conflito"
  "o-colega-invisivel"
  "conflito-com-o-colega"
  "publique-no-github"
  "seu-primeiro-pull-request"
)
ULTIMO_LAB_LOCAL=14   # o 15 continua na pasta do 14, já ligada ao GitHub do aluno

# Identidades usadas nos históricos gerados.
CHEF_NOME="Chef do Curso"
CHEF_EMAIL="chef@curso.exemplo"
COLEGA_NOME="Colega Invisível"
COLEGA_EMAIL="colega@curso.exemplo"

# ---------------------------------------------------------------------------
# Saída
# ---------------------------------------------------------------------------
if [[ -t 1 ]]; then
  C_VERDE=$'\e[32m'; C_VERM=$'\e[31m'; C_AMAR=$'\e[33m'; C_AZUL=$'\e[34m'
  C_NEG=$'\e[1m'; C_FIM=$'\e[0m'
else
  C_VERDE=""; C_VERM=""; C_AMAR=""; C_AZUL=""; C_NEG=""; C_FIM=""
fi

info()  { printf '%s\n' "${C_AZUL}▶${C_FIM} $*"; }
ok()    { printf '%s\n' "${C_VERDE}✅${C_FIM} $*"; }
aviso() { printf '%s\n' "${C_AMAR}⚠️ ${C_FIM} $*"; }
erro()  { printf '%s\n' "${C_VERM}❌${C_FIM} $*" >&2; }

# ---------------------------------------------------------------------------
# Números e caminhos dos desafios
# ---------------------------------------------------------------------------

# normalizar_num "5" | "05" | "05-nome"  ->  "05"
normalizar_num() {
  local n="${1%%-*}"
  [[ "$n" =~ ^[0-9]{1,2}$ ]] || return 1
  printf '%02d' "$((10#$n))"
}

lab_nome()   { printf '%s' "${LAB_NOMES[$((10#$1))]:-}"; }
lab_dir()    { printf '%s/%s-%s' "$LABS_DIR" "$1" "$(lab_nome "$1")"; }
lab_remoto() { printf '%s/%s.git' "$REMOTOS_DIR" "$1"; }

# Descobre o desafio a partir do diretório atual (LABS_DIR/NN-nome/...).
detectar_lab() {
  local rel="${PWD#"$LABS_DIR"/}"
  [[ "$rel" != "$PWD" ]] || return 1
  local nn="${rel%%/*}"
  nn="${nn%%-*}"
  [[ "$nn" =~ ^[0-9]{2}$ ]] || return 1
  printf '%s' "$nn"
}

# resolver_lab [NN]  -> imprime "NN" a partir do argumento ou do diretório atual
resolver_lab() {
  local nn
  if [[ -n "${1:-}" ]]; then
    nn="$(normalizar_num "$1")" || { erro "Número de desafio inválido: '$1'. Use algo como 05."; return 1; }
  else
    nn="$(detectar_lab)" || {
      erro "Informe o número do desafio. Exemplo: $(basename "$0") 05"
      return 1
    }
  fi
  local n=$((10#$nn))
  if (( n < 0 || n > 15 )); then
    erro "O desafio $nn não existe. Use um número de 00 a 15."
    return 1
  fi
  printf '%s' "$nn"
}

# ---------------------------------------------------------------------------
# Git determinístico para gerar os históricos dos labs
# ---------------------------------------------------------------------------

# git sem assinatura, sem hooks e sem abrir editor.
g() { git -c commit.gpgsign=false -c core.hooksPath=/dev/null -c core.editor=true "$@"; }

# Relógio fictício: 1º de setembro de 2026, 09:00 UTC. Cada commit avança 1 hora,
# o que deixa os hashes dos labs iguais em todas as máquinas.
LAB_RELOGIO=1788253200

# commit_como "Nome" "email" "mensagem"  (faz git add -A antes)
commit_como() {
  local nome="$1" email="$2" msg="$3"
  LAB_RELOGIO=$((LAB_RELOGIO + 3600))
  local data="$LAB_RELOGIO +0000"
  g add -A
  GIT_AUTHOR_NAME="$nome" GIT_AUTHOR_EMAIL="$email" \
  GIT_COMMITTER_NAME="$nome" GIT_COMMITTER_EMAIL="$email" \
  GIT_AUTHOR_DATE="$data" GIT_COMMITTER_DATE="$data" \
    g commit -q --allow-empty -m "$msg"
}

commit_chef()   { commit_como "$CHEF_NOME" "$CHEF_EMAIL" "$1"; }
commit_colega() { commit_como "$COLEGA_NOME" "$COLEGA_EMAIL" "$1"; }

# Metadados do lab, guardados dentro de .git/lab/ (invisíveis para o git).
lab_meta_set() { mkdir -p .git/lab; printf '%s\n' "$2" > ".git/lab/$1"; }
lab_meta_get() { cat ".git/lab/$1" 2>/dev/null || true; }
