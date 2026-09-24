#!/usr/bin/env bash
# Verificações de cada desafio. Carregado por check.sh.
# Cada função verificar_NN roda dentro da pasta do desafio e registra falhas
# com falhar "o que está errado" "dica". A missão extra usa extra_ok / extra_nao.

FALHAS=()
EXTRA=""

falhar()    { FALHAS+=("$1"$'\n'"   💡 $2"); }
extra_ok()  { EXTRA="ok"; }
extra_nao() { EXTRA="nao"; }

# --- predicados auxiliares ---------------------------------------------------

arvore_limpa()      { [[ -z "$(g status --porcelain)" ]]; }
branch_atual()      { g symbolic-ref --short -q HEAD || printf 'HEAD solta'; }
tem_commit()        { g rev-parse --verify -q HEAD >/dev/null 2>&1; }
existe_no_head()    { g cat-file -e "HEAD:$1" 2>/dev/null; }
commits_desde()     { g rev-list --count "$1..HEAD"; }
merges_desde()      { g rev-list --merges "$1..HEAD"; }
n_pais()            { g rev-list --parents -n 1 "$1" | wc -w | awk '{print $1-1}'; }
existe_branch()     { g show-ref --verify -q "refs/heads/$1"; }
tem_marcadores()    { grep -rlE '^(<{7}|={7}|>{7})( |$)' --exclude-dir=.git . 2>/dev/null; }

exigir_arvore_limpa() {
  arvore_limpa || falhar "Ainda há mudanças não commitadas (veja git status)." \
    "Faça commit do que falta ou desfaça o que não deveria estar aí."
}

exigir_branch() {
  local atual; atual="$(branch_atual)"
  [[ "$atual" == "$1" ]] || falhar "Você está na branch '$atual', mas deveria terminar na '$1'." \
    "Use: git switch $1"
}

exigir_sem_merge_pendente() {
  if [[ -f .git/MERGE_HEAD ]]; then
    falhar "Há um merge em andamento que não foi concluído." \
      "Resolva os conflitos, rode git add <arquivo> e depois git commit."
  fi
}

# ---------------------------------------------------------------------------
# Desafio 0 — Configure sua identidade (não depende de pasta de lab)
# ---------------------------------------------------------------------------
verificar_00() {
  local nome email
  nome="$(git config --global --get user.name || true)"
  email="$(git config --global --get user.email || true)"

  if [[ -z "$nome" ]]; then
    falhar "user.name não está configurado." \
      'git config --global user.name "<seu nome completo>"'
  elif [[ "${nome,,}" == *"fulano"* || "${nome,,}" == *"seu nome"* || "${nome,,}" == *"beltrano"* || "${nome,,}" == *"sicrano"* ]]; then
    falhar "user.name ainda é um exemplo ('$nome')." \
      "Use o seu nome de verdade: é ele que vai assinar cada commit."
  fi

  if [[ -z "$email" ]]; then
    falhar "user.email não está configurado." \
      'git config --global user.email <e-mail da sua conta GitHub>'
  elif [[ "$email" != *@*.* ]]; then
    falhar "user.email ('$email') não parece um e-mail." "Confira se digitou o endereço completo."
  elif [[ "${email,,}" == *"fulanodetal"* || "${email,,}" == voce@* || "${email,,}" == *"@exemplo."* ]]; then
    falhar "user.email ainda é um exemplo ('$email')." \
      "Use o e-mail da sua conta GitHub, senão os commits não aparecem ligados ao seu perfil."
  fi

  local branch editor
  branch="$(git config --global --get init.defaultBranch || true)"
  editor="$(git config --global --get core.editor || true)"
  [[ "$branch" == "main" ]] || falhar "init.defaultBranch não está definido como main." \
    "git config --global init.defaultBranch main"
  [[ -n "$editor" ]] || falhar "core.editor não está definido; o Git pode abrir o Vim no meio da aula." \
    'git config --global core.editor "code --wait"'

  if (( ${#FALHAS[@]} == 0 )); then
    info "Identidade: $nome <$email>"
  fi
}

# ---------------------------------------------------------------------------
# Desafio 1 — Meu primeiro repositório
# ---------------------------------------------------------------------------
verificar_01() {
  if [[ ! -d .git ]]; then
    falhar "Esta pasta ainda não é um repositório Git." "Rode git init dentro da pasta do desafio."
    return
  fi
  if ! tem_commit; then
    falhar "O repositório existe, mas ainda não tem nenhum commit." \
      "Use git add . e depois git commit -m \"Cria o livro de receitas\"."
    return
  fi
  local nao_rastreados; nao_rastreados="$(g ls-files --others --exclude-standard)"
  [[ -z "$nao_rastreados" ]] || falhar "Ainda há arquivos não rastreados: $(echo "$nao_rastreados" | tr '\n' ' ')" \
    "Adicione com git add e faça commit."
  local n_md; n_md="$(g ls-files | grep -c '\.md$' || true)"
  (( n_md >= 3 )) || falhar "Só $n_md receita(s) estão no repositório; esperava 3." \
    "Confira com git status quais arquivos faltam."
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Desafio 2 — Registrando mudanças
# ---------------------------------------------------------------------------
verificar_02() {
  local total; total="$(g rev-list --count HEAD)"
  (( total >= 4 )) || falhar "O histórico tem $total commit(s); o desafio pede pelo menos 4." \
    "Altere uma receita, git add, git commit -m \"...\" e repita."
  local repetidas; repetidas="$(g log --format=%s | sort | uniq -d)"
  [[ -z "$repetidas" ]] || falhar "Há mensagens de commit repetidas: $(echo "$repetidas" | tr '\n' ';')" \
    "Cada mensagem deve dizer o que mudou naquele commit."
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Desafio 3 — Commit cirúrgico
# ---------------------------------------------------------------------------
verificar_03() {
  local base; base="$(lab_meta_get base)"
  local n; n="$(commits_desde "$base")"
  if (( n < 2 )); then
    falhar "Há $n commit(s) novo(s); esperava um para cada arquivo (2)." \
      "Use git add <arquivo> com um arquivo por vez e faça commit entre eles."
  fi
  local c arquivos tocou_bolo=0 tocou_brig=0 n_pao=0
  for c in $(g rev-list "$base..HEAD"); do
    arquivos="$(g diff-tree --no-commit-id --name-only -r "$c")"
    local qtd; qtd="$(echo "$arquivos" | grep -c . || true)"
    if (( qtd != 1 )); then
      falhar "O commit $(g log -1 --format='%h \"%s\"' "$c") toca $qtd arquivos." \
        "Cada commit deste desafio deve tocar exatamente um arquivo."
    fi
    grep -qx 'bolo-de-cenoura.md' <<<"$arquivos" && tocou_bolo=1
    grep -qx 'brigadeiro.md' <<<"$arquivos" && tocou_brig=1
    grep -qx 'pao-de-queijo.md' <<<"$arquivos" && n_pao=$((n_pao + 1))
  done
  (( tocou_bolo )) || falhar "Nenhum commit novo contém a mudança em bolo-de-cenoura.md." \
    "git add bolo-de-cenoura.md && git commit -m \"...\""
  (( tocou_brig )) || falhar "Nenhum commit novo contém a mudança em brigadeiro.md." \
    "git add brigadeiro.md && git commit -m \"...\""
  [[ -z "$(g status --porcelain -- bolo-de-cenoura.md brigadeiro.md)" ]] || \
    falhar "As mudanças no bolo e no brigadeiro ainda não estão todas commitadas." "Veja git status."
  if (( n_pao >= 2 )); then extra_ok; else extra_nao; fi
}

# ---------------------------------------------------------------------------
# Desafio 4 — Ignorando o que não importa
# ---------------------------------------------------------------------------
verificar_04() {
  if ! existe_no_head .gitignore; then
    falhar "O arquivo .gitignore ainda não foi commitado." \
      "Crie o .gitignore, confira com git status e faça commit dele."
  fi
  local p
  for p in debug.log erros.log build/livro.html .env; do
    g check-ignore -q "$p" || falhar "O arquivo $p não está sendo ignorado." \
      "Adicione um padrão ao .gitignore (por exemplo *.log, build/ ou .env) e confira com git check-ignore -v $p"
  done
  local rastreado_ignorado; rastreado_ignorado="$(g ls-files -ci --exclude-standard | grep -v '^antigo.log$' || true)"
  [[ -z "$rastreado_ignorado" ]] || falhar "Arquivos ignorados continuam rastreados: $(echo "$rastreado_ignorado" | tr '\n' ' ')" \
    "git rm --cached <arquivo> e commit."
  exigir_arvore_limpa
  # Missão extra: antigo.log estava rastreado e deve sair do repositório, sem sair do disco
  if ! existe_no_head antigo.log && [[ -f antigo.log ]] && g check-ignore -q antigo.log; then
    extra_ok
  else
    extra_nao
  fi
}

# ---------------------------------------------------------------------------
# Desafio 5 — Detetive do histórico
# ---------------------------------------------------------------------------
verificar_05() {
  if [[ ! -f respostas.txt ]]; then
    falhar "O arquivo respostas.txt não existe." "Ele foi apagado? Recupere com git restore respostas.txt"
    return
  fi
  mapfile -t R < <(grep -E '^R:' respostas.txt | sed -E 's/^R:[[:space:]]*//; s/[[:space:]]+$//')
  local r1="${R[0]:-}" r2="${R[1]:-}" r3="${R[2]:-}"

  local autor_preco; autor_preco="$(g log --format=%an -S'45,00' -- bolo-de-cenoura.md | tail -1)"
  local hash_pao;    hash_pao="$(g log --format=%H --diff-filter=A -- pao-caseiro.md)"

  local primeiro_nome="${autor_preco%% *}"; primeiro_nome="${primeiro_nome,,}"
  if [[ -z "$r1" ]]; then
    falhar "A resposta 1 está em branco." "Tente git blame bolo-de-cenoura.md ou git log -S\"45,00\" -- bolo-de-cenoura.md"
  elif [[ "${r1,,}" != *"$primeiro_nome"* ]]; then
    falhar "A resposta 1 ('$r1') não confere." "Quem foi a última pessoa a mexer na linha do preço? git blame mostra."
  fi

  local r2l="${r2,,}"
  if [[ -z "$r2" ]]; then
    falhar "A resposta 2 está em branco." "Tente git log --oneline -- pao-caseiro.md"
  elif (( ${#r2l} < 4 )) || [[ "$hash_pao" != "$r2l"* ]]; then
    falhar "A resposta 2 ('$r2') não é o hash do commit que criou pao-caseiro.md." \
      "git log --oneline -- pao-caseiro.md mostra os commits que tocaram o arquivo; o mais antigo é o que criou."
  fi

  if [[ -z "$r3" ]]; then
    falhar "A resposta 3 está em branco." "Ache o hash com git log --oneline e veja a mudança com git show <hash>"
  elif ! grep -qE '(^|[^0-9])12([^0-9]|$)' <<<"$r3"; then
    falhar "A resposta 3 ('$r3') não confere." "Use git show no commit \"Ajusta porções\" e leia a linha marcada com +."
  fi
}

# ---------------------------------------------------------------------------
# Desafio 6 — Desfazendo antes do commit
# ---------------------------------------------------------------------------
verificar_06() {
  local base; base="$(lab_meta_get base)"
  if (( $(commits_desde "$base") > 0 )); then
    falhar "Você fez um commit, mas este desafio se resolve sem commit nenhum." \
      "Recomece com: reset.sh 06"
    return
  fi
  g diff --quiet HEAD -- bolo-de-cenoura.md || falhar "bolo-de-cenoura.md ainda não voltou ao conteúdo do último commit." \
    "git restore bolo-de-cenoura.md"
  g diff --cached --quiet || falhar "Ainda há algo na staging area: $(g diff --cached --name-only | tr '\n' ' ')" \
    "git restore --staged <arquivo>"
  [[ -f notas-pessoais.md ]] || falhar "notas-pessoais.md foi apagado; a ideia era só tirá-lo da staging." \
    "Recomece com: reset.sh 06"
}

# ---------------------------------------------------------------------------
# Desafio 7 — Desfazendo depois do commit
# ---------------------------------------------------------------------------
verificar_07() {
  local base bug; base="$(lab_meta_get base)"; bug="$(lab_meta_get bug)"
  exigir_sem_merge_pendente
  if [[ -f .git/REVERT_HEAD ]]; then
    falhar "Há um revert em andamento." "Conclua com git revert --continue ou cancele com git revert --abort."
  fi
  if g log --format=%s | grep -q 'pudin'; then
    falhar "A mensagem com erro de digitação (\"pudin\") ainda está no histórico." \
      "Se ela é o último commit: git commit --amend -m \"Adiciona receita de pudim\". Se não é mais, recomece com reset.sh 07."
  fi
  g log --format=%s | grep -q 'pudim' || falhar "Não encontrei um commit com a mensagem corrigida (\"pudim\")." \
    "git commit --amend -m \"Adiciona receita de pudim\""
  if g merge-base --is-ancestor "$bug" HEAD; then
    :
  else
    falhar "O commit que introduziu o bug sumiu do histórico." \
      "O revert cria um commit novo que desfaz o antigo, sem apagá-lo. Recomece com reset.sh 07 e use git revert."
  fi
  if g show HEAD:brigadeiro.md 2>/dev/null | grep -q 'colher de sopa de sal'; then
    falhar "O brigadeiro ainda leva sal." "Encontre o commit culpado com git log --oneline e desfaça com git revert <hash>."
  fi
  g show HEAD:brigadeiro.md 2>/dev/null | grep -q 'manteiga' || falhar "brigadeiro.md não tem mais a manteiga." \
    "O revert deveria devolver a linha original."
  g rev-list "$base..HEAD" --format=%s | grep -qi '^revert' || falhar "Não há um commit de revert no histórico." \
    "git revert <hash-do-commit-do-bug>"
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Desafio 8 — Branch de funcionalidade
# ---------------------------------------------------------------------------
verificar_08() {
  local base; base="$(lab_meta_get base)"
  exigir_branch main
  existe_no_head sobremesas.md || falhar "sobremesas.md não está na main." \
    "Crie o arquivo na branch feature/sobremesas, faça commit, volte para main e rode git merge feature/sobremesas."
  local n; n="$(commits_desde "$base")"
  (( n >= 2 )) || falhar "A main tem $n commit(s) novo(s); esperava pelo menos 2 vindos da branch." \
    "Faça dois commits na feature/sobremesas antes do merge."
  [[ -z "$(merges_desde "$base")" ]] || falhar "Apareceu um merge commit, mas aqui o merge deveria ser fast-forward." \
    "Não faça commits na main antes do merge; recomece com reset.sh 08 se precisar."
  if existe_branch feature/sobremesas; then
    g merge-base --is-ancestor feature/sobremesas main || falhar "A feature/sobremesas tem commits que não chegaram na main." \
      "git switch main && git merge feature/sobremesas"
    if (( n >= 2 )) && ! g rev-list "$base..feature/sobremesas" | grep -q .; then
      falhar "Os commits novos foram feitos direto na main; a feature/sobremesas ficou para trás." \
        "A ideia é commitar na branch e trazer para a main com merge. Recomece com reset.sh 08."
    fi
  else
    falhar "A branch feature/sobremesas não existe." "git switch -c feature/sobremesas"
  fi
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Desafio 9 — Caminhos que divergem
# ---------------------------------------------------------------------------
verificar_09() {
  local base; base="$(lab_meta_get base)"
  exigir_branch main
  exigir_sem_merge_pendente
  [[ -n "$(merges_desde "$base")" ]] || falhar "Não há merge commit na main." \
    "git merge feature/bebidas (o Git vai abrir o editor para a mensagem; salve e feche)."
  existe_no_head bebidas.md || falhar "bebidas.md não está na main." "O merge trouxe a branch inteira?"
  if existe_branch feature/bebidas; then
    falhar "A branch feature/bebidas ainda existe." "Depois do merge, apague com git branch -d feature/bebidas"
  fi
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Desafio 10 — Guardando para depois
# ---------------------------------------------------------------------------
verificar_10() {
  local base; base="$(lab_meta_get base)"
  local bolo_main; bolo_main="$(g show main:bolo-de-cenoura.md)"
  if grep -q '1800 graus' <<<"$bolo_main"; then
    falhar "O bolo na main ainda vai ao forno a 1800 graus." \
      "Guarde seu trabalho com git stash, vá para a main, corrija para 180 e faça commit."
  fi
  (( $(g rev-list --count "$base..main") >= 1 )) || falhar "A main não tem commit novo com a correção." \
    "git switch main, corrija, git commit -am \"Corrige temperatura do forno\""
  [[ -z "$(g stash list)" ]] || falhar "Ainda há algo guardado no stash." "git stash pop (na branch feature/sopas)"
  exigir_branch feature/sopas
  local sopas
  sopas="$(cat sopas.md 2>/dev/null || true)"
  if ! grep -q '2 batatas' <<<"$sopas"; then
    falhar "O trabalho em sopas.md (as batatas, cenouras...) não voltou." \
      "Na branch feature/sopas, rode git stash pop."
  fi
  [[ -z "$(merges_desde "$base")" ]] || falhar "Apareceu um merge commit, o que não era esperado aqui." \
    "Recomece com reset.sh 10 se ficou confuso."
}

# ---------------------------------------------------------------------------
# Desafio 11 — Resolva o conflito
# ---------------------------------------------------------------------------
verificar_11() {
  local base tip; base="$(lab_meta_get base)"; tip="$(lab_meta_get tip_ajuste)"
  exigir_branch main
  if [[ -f .git/MERGE_HEAD ]]; then
    falhar "O merge ainda não foi concluído." \
      "Edite bolo-de-cenoura.md, remova os marcadores, git add bolo-de-cenoura.md e git commit."
    return
  fi
  local m; m="$(tem_marcadores || true)"
  [[ -z "$m" ]] || falhar "Ainda há marcadores de conflito em: $(echo "$m" | tr '\n' ' ')" \
    "Apague as linhas <<<<<<<, ======= e >>>>>>> deixando só o conteúdo final."
  if ! g merge-base --is-ancestor "$tip" HEAD; then
    falhar "A branch ajuste-preco ainda não foi integrada à main." "git merge ajuste-preco"
  elif [[ -z "$(merges_desde "$base")" ]]; then
    falhar "Não encontrei o merge commit." "Depois de resolver o conflito, git add e git commit."
  fi
  if ! g show HEAD:bolo-de-cenoura.md | grep -qE 'Preço sugerido: R\$ [0-9]+,[0-9]{2}$'; then
    falhar "A linha do preço no bolo ficou estranha." "Deixe uma linha só, no formato 'Preço sugerido: R\$ 48,00'."
  fi
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Desafios 12 e 13 — remoto simulado
# ---------------------------------------------------------------------------
verificar_remoto_comum() {
  local nn="$1"
  local bare; bare="$(lab_remoto "$nn")"
  local base; base="$(lab_meta_get base)"
  exigir_branch main
  exigir_sem_merge_pendente
  g fetch -q origin
  local remoto_head; remoto_head="$(g rev-parse origin/main)"
  if ! g -C "$bare" log --format=%an "$base..main" | grep -q "$COLEGA_NOME"; then
    falhar "O colega ainda não publicou nada no remoto." "Rode: colega.sh $nn"
  fi
  if [[ "$(g rev-parse HEAD)" != "$remoto_head" ]]; then
    local ahead behind
    ahead="$(g rev-list --count origin/main..HEAD)"; behind="$(g rev-list --count HEAD..origin/main)"
    falhar "Sua main e a origin/main não estão iguais (você está $ahead à frente e $behind atrás)." \
      "Se estiver atrás: git pull. Se estiver à frente: git push."
  fi
  if ! g -C "$bare" log --format=%an "$base..main" | grep -v "$COLEGA_NOME" | grep -q .; then
    falhar "O remoto ainda não tem nenhum commit seu." "Faça commit e git push."
  fi
  exigir_arvore_limpa
}

verificar_12() { verificar_remoto_comum 12; }

verificar_13() {
  verificar_remoto_comum 13
  local base; base="$(lab_meta_get base)"
  local m; m="$(tem_marcadores || true)"
  [[ -z "$m" ]] || falhar "Ainda há marcadores de conflito em: $(echo "$m" | tr '\n' ' ')" \
    "Edite o arquivo deixando só o conteúdo final, depois git add e git commit."
  [[ -n "$(merges_desde "$base")" ]] || falhar "Não há merge commit integrando a mudança do colega." \
    "git pull traz o commit do colega; resolva o conflito, git add, git commit e git push."
}

# ---------------------------------------------------------------------------
# Desafios 14 e 15 — na pasta do 14, ligada ao GitHub de verdade
# ---------------------------------------------------------------------------
sincronizar_com_github() {
  if ! g remote get-url origin >/dev/null 2>&1; then
    falhar "Este repositório ainda não tem um remoto chamado origin." \
      "Crie um repositório vazio no GitHub e ligue com: git remote add origin https://github.com/<você>/<nome>.git"
    return 1
  fi
  if ! g fetch -q origin 2>/dev/null; then
    aviso "Não consegui fazer git fetch no GitHub; comparando com a última origin/main conhecida."
  fi
  if ! g rev-parse --verify -q origin/main >/dev/null; then
    falhar "O GitHub ainda não tem a branch main deste repositório." "git push -u origin main"
    return 1
  fi
  return 0
}

verificar_14() {
  exigir_branch main
  existe_no_head aprendizados.md || falhar "aprendizados.md não está commitado." \
    "Crie o arquivo com três coisas que aprendeu, git add aprendizados.md e git commit."
  sincronizar_com_github || return 0
  if [[ "$(g rev-parse HEAD)" != "$(g rev-parse origin/main)" ]]; then
    falhar "A main local e a origin/main são diferentes." "git push (ou git pull, se o GitHub tiver algo que você não tem)."
  fi
  if [[ "$(g rev-parse --abbrev-ref 'main@{upstream}' 2>/dev/null || true)" != "origin/main" ]]; then
    falhar "A main local não está ligada à origin/main (sem upstream)." "git push -u origin main"
  fi
  exigir_arvore_limpa
}

verificar_15() {
  exigir_branch main
  sincronizar_com_github || return 0
  if [[ "$(g rev-parse HEAD)" != "$(g rev-parse origin/main)" ]]; then
    falhar "A main local está diferente da origin/main." "Depois do merge do PR na web: git switch main && git pull"
  fi
  local n; n="$(g rev-list --count HEAD -- aprendizados.md)"
  (( n >= 2 )) || falhar "aprendizados.md tem $n commit(s); esperava pelo menos 2 (o do desafio 14 e o do PR)." \
    "Edite o arquivo numa branch, faça commit, push, abra o PR e faça merge."
  local outras; outras="$(g branch --format='%(refname:short)' | grep -vx main || true)"
  if [[ -n "$outras" ]]; then
    local pendentes; pendentes="$(g branch --no-merged main --format='%(refname:short)' || true)"
    if [[ -n "$pendentes" ]]; then
      falhar "A(s) branch(es) $(echo "$pendentes" | tr '\n' ' ') ainda não foram integradas à main." \
        "Faça o merge do PR no GitHub e depois git pull na main."
    else
      falhar "A(s) branch(es) local(is) $(echo "$outras" | tr '\n' ' ') já foram integradas; apague-as." \
        "git branch -d <nome-da-branch>"
    fi
  fi
  exigir_arvore_limpa
}

# ---------------------------------------------------------------------------
# Relatório
# ---------------------------------------------------------------------------
relatorio() {
  local nn="$1"
  local titulo; titulo="Desafio $nn — $(lab_nome "$nn")"
  if (( ${#FALHAS[@]} == 0 )); then
    ok "${C_NEG}$titulo${C_FIM}: concluído! 🎉"
  else
    erro "${C_NEG}$titulo${C_FIM}: ainda não. Encontrei ${#FALHAS[@]} ponto(s) para ajustar:"
    local f
    for f in "${FALHAS[@]}"; do printf '\n • %s\n' "$f"; done
    printf '\n'
  fi
  case "$EXTRA" in
    ok)  ok "Missão extra: concluída!" ;;
    nao) info "Missão extra: ainda não (opcional)." ;;
  esac
  (( ${#FALHAS[@]} == 0 ))
}
