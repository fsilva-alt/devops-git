#!/usr/bin/env bash
# Verifica se o desafio NN foi concluído e, se não, dá dicas.
#
# Uso:
#   check.sh 05          # verifica o desafio 5
#   check.sh             # dentro da pasta de um laboratório, detecta o desafio
#
# Sai com código 0 quando o desafio está concluído e 1 quando ainda não.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$SCRIPTS_DIR/checks.sh"

nn="$(resolver_lab "${1:-}")" || exit 2
n=$((10#$nn))

if (( n == 0 )); then
  :   # não depende de pasta
else
  pasta_nn="$nn"
  (( n == 15 )) && pasta_nn=14     # o desafio 15 continua na pasta do 14
  dir="$(lab_dir "$pasta_nn")"
  if [[ ! -d "$dir" ]]; then
    erro "A pasta do desafio $pasta_nn não existe ($dir)."
    info "Gere com: setup.sh   (ou reset.sh $pasta_nn)"
    exit 2
  fi
  cd "$dir"
fi

"verificar_$nn"
relatorio "$nn"
