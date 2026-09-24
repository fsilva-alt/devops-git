#!/usr/bin/env bash
# Recria o desafio NN no estado inicial, sem mexer nos demais.
# ATENÇÃO: apaga tudo o que você fez naquele desafio.
#
# Uso:
#   reset.sh 07          # recria o desafio 7
#   reset.sh             # dentro da pasta de um laboratório, detecta o desafio

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$SCRIPTS_DIR/labs.sh"

nn="$(resolver_lab "${1:-}")" || exit 2
n=$((10#$nn))

if (( n == 0 )); then
  erro "O desafio 00 é só configuração do Git; não há o que recriar."
  info "Para refazer, rode de novo os comandos git config --global do enunciado."
  exit 2
fi
if (( n == 15 )); then
  erro "O desafio 15 acontece na pasta do desafio 14. Para recomeçar os dois: reset.sh 14"
  exit 2
fi
if (( n == 14 )); then
  aviso "Isso apaga a pasta local, não o repositório no GitHub. Ao refazer, apague ou reutilize o repositório de lá."
fi

dir="$(lab_dir "$nn")"

# Se o aluno estiver dentro da pasta que vai ser apagada, o shell dele ficaria
# num diretório inexistente. Avisa para ele fazer cd de novo.
dentro=0
[[ "$PWD" == "$dir"* ]] && dentro=1

info "Recriando o desafio $nn em $dir ..."
gerar_lab "$nn"
ok "Desafio $nn de volta ao estado inicial."
if (( dentro )); then
  aviso "Você estava dentro da pasta recriada. Rode: cd \"$dir\""
fi
