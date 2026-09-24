#!/usr/bin/env bash
# Roda a suíte de testes dentro de um container Ubuntu limpo.
#
# Uso:  tests/rodar.sh
#
# Constrói a imagem de tests/Dockerfile (um "Codespace em branco"), monta este
# repositório em /workspaces/devops-git (somente leitura) e executa
# tests/solucoes.sh, que roda o install.sh como um aluno faria e depois resolve
# cada desafio nos três cenários (vazio, errado, certo), conferindo check.sh.

set -euo pipefail
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGEM="curso-git-testes"

docker build -q -t "$IMAGEM" -f "$RAIZ/tests/Dockerfile" "$RAIZ/tests" >/dev/null
docker run --rm -t \
  -v "$RAIZ:/workspaces/devops-git:ro" \
  "$IMAGEM" bash /workspaces/devops-git/tests/solucoes.sh
