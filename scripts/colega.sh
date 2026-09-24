#!/usr/bin/env bash
# Simula um colega de equipe publicando um commit no remoto dos desafios 12 e 13.
#
# Uso:
#   colega.sh 12         # o colega acrescenta um aviso em avisos.md
#   colega.sh 13         # o colega muda o preço do bolo (a mesma linha que você)
#   colega.sh            # dentro da pasta do laboratório, detecta o desafio

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

nn="$(resolver_lab "${1:-}")" || exit 2
n=$((10#$nn))

if (( n != 12 && n != 13 )); then
  erro "O colega só trabalha nos desafios 12 e 13."
  exit 2
fi

bare="$(lab_remoto "$nn")"
if [[ ! -d "$bare" ]]; then
  erro "O remoto do desafio $nn não existe. Gere com: reset.sh $nn"
  exit 2
fi

if g -C "$bare" log --format=%an main 2>/dev/null | grep -q "$COLEGA_NOME"; then
  aviso "O colega já publicou o commit dele. Veja com: git fetch && git log --oneline main..origin/main"
  exit 0
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

g clone -q "$bare" "$tmp/clone"
cd "$tmp/clone"

case "$n" in
  12)
    printf -- '- Desligar o forno ao sair.\n' >> avisos.md
    commit_colega "Adiciona aviso sobre o forno"
    ;;
  13)
    sed -i -E 's/^Preço sugerido: R\$ .*$/Preço sugerido: R$ 55,00/' bolo-de-cenoura.md
    commit_colega "Reajusta preço do bolo para R\$ 55,00"
    ;;
esac
g push -q origin main

info "💬 Colega Invisível: \"Acabei de subir uma mudança na main, dá um pull aí!\""
ok "Commit publicado no remoto: $(g log -1 --format='%h %s')"
