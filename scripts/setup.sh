#!/usr/bin/env bash
# Prepara o ambiente do curso: configura o Git com valores seguros para a aula
# e gera os laboratórios 01 a 14 em $LABS_DIR (por padrão ~/labs).
#
# Uso:
#   setup.sh            # gera só o que ainda não existe (idempotente)
#   setup.sh --force    # apaga e regenera todos os laboratórios
#
# O install.sh roda este script automaticamente.

source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
source "$SCRIPTS_DIR/labs.sh"

FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

# --- Configuração global do Git (só o que ainda não estiver definido) ---------
# A identidade (user.name / user.email) fica de propósito para o Desafio 0.
definir_padrao() {
  if [[ -z "$(git config --global --get "$1" || true)" ]]; then
    git config --global "$1" "$2"
    info "git config --global $1 \"$2\""
  fi
}
definir_padrao init.defaultBranch main
definir_padrao core.editor "code --wait"
definir_padrao pull.rebase false        # git pull faz merge, como ensinado na aula
definir_padrao merge.conflictstyle merge

# --- Laboratórios --------------------------------------------------------------
mkdir -p "$LABS_DIR"
info "Laboratórios em: $LABS_DIR"

gerados=0; mantidos=0
for n in $(seq 1 "$ULTIMO_LAB_LOCAL"); do
  nn="$(printf '%02d' "$n")"
  dir="$(lab_dir "$nn")"
  if [[ -d "$dir" && $FORCE -eq 0 ]]; then
    mantidos=$((mantidos + 1))
    continue
  fi
  gerar_lab "$nn"
  gerados=$((gerados + 1))
done

ok "Pronto: $gerados laboratório(s) gerado(s), $mantidos mantido(s)."
if (( mantidos > 0 )); then
  info "Para recomeçar um desafio específico: reset.sh NN"
fi
