#!/usr/bin/env bash
# Geradores dos laboratórios 01 a 13. Carregado por setup.sh e reset.sh.
# Cada função gerar_NN cria a pasta do desafio já no estado inicial descrito
# em exercises/NN-nome/README.md.

# ---------------------------------------------------------------------------
# Conteúdo das receitas (o "projeto" que os alunos versionam)
# ---------------------------------------------------------------------------

# receita_bolo [porções] [preço] [temperatura]
receita_bolo() {
cat <<EOF
# Bolo de cenoura

Rende: ${1:-8} porções
Preço sugerido: R\$ ${2:-40,00}

## Ingredientes

- 3 cenouras médias
- 4 ovos
- 1 xícara de óleo
- 2 xícaras de açúcar
- 2 xícaras de farinha de trigo
- 1 colher de sopa de fermento em pó

## Modo de preparo

1. Bata no liquidificador as cenouras, os ovos e o óleo.
2. Misture o açúcar e a farinha.
3. Acrescente o fermento e misture devagar.
4. Asse em forno a ${3:-180} graus por 40 minutos.
EOF
}

# receita_brigadeiro [gordura]   (a gordura certa é "manteiga")
receita_brigadeiro() {
cat <<EOF
# Brigadeiro

Rende: 30 unidades

## Ingredientes

- 1 lata de leite condensado
- 3 colheres de sopa de chocolate em pó
- 1 colher de sopa de ${1:-manteiga}
- Chocolate granulado para enrolar

## Modo de preparo

1. Misture tudo numa panela em fogo baixo.
2. Mexa sem parar até desgrudar do fundo.
3. Deixe esfriar, enrole e passe no granulado.
EOF
}

receita_pao_de_queijo() {
cat <<EOF
# Pão de queijo

Rende: 25 unidades

## Ingredientes

- 500 g de polvilho azedo
- 1 xícara de leite
- 1/2 xícara de óleo
- 2 ovos
- 200 g de queijo minas ralado
- 1 colher de chá de sal

## Modo de preparo

1. Ferva o leite com o óleo e o sal.
2. Despeje sobre o polvilho e misture.
3. Acrescente os ovos e o queijo.
4. Faça bolinhas e asse a 180 graus por 25 minutos.
EOF
}

receita_mousse() {
cat <<EOF
# Mousse de maracujá

Rende: 6 porções

## Ingredientes

- 1 lata de leite condensado
- 1 lata de creme de leite
- 1 xícara de suco concentrado de maracujá

## Modo de preparo

1. Bata tudo no liquidificador por 3 minutos.
2. Leve à geladeira por 2 horas.
EOF
}

receita_limonada() {
cat <<EOF
# Limonada

Rende: 4 copos

## Ingredientes

- 2 limões
- 1 litro de água gelada
- Açúcar a gosto

## Modo de preparo

1. Bata os limões com casca e a água no liquidificador.
2. Coe, adoce e sirva.
EOF
}

# Cria um repositório em DIR com o commit inicial do livro de receitas.
criar_base_receitas() {
  local dir="$1"
  mkdir -p "$dir"
  cd "$dir"
  g init -q -b main
  receita_bolo > bolo-de-cenoura.md
  receita_brigadeiro > brigadeiro.md
  receita_pao_de_queijo > pao-de-queijo.md
  commit_chef "Cria o livro de receitas"
  lab_meta_set base "$(g rev-parse HEAD)"
}

# ---------------------------------------------------------------------------
# Desafio 1 — Meu primeiro repositório
# ---------------------------------------------------------------------------
gerar_01() {
  local dir; dir="$(lab_dir 01)"
  mkdir -p "$dir"
  receita_bolo > "$dir/bolo-de-cenoura.md"
  receita_brigadeiro > "$dir/brigadeiro.md"
  receita_pao_de_queijo > "$dir/pao-de-queijo.md"
}

# ---------------------------------------------------------------------------
# Desafio 2 — Registrando mudanças
# ---------------------------------------------------------------------------
gerar_02() {
  ( criar_base_receitas "$(lab_dir 02)" )
}

# ---------------------------------------------------------------------------
# Desafio 3 — Commit cirúrgico
# ---------------------------------------------------------------------------
gerar_03() {
  (
    criar_base_receitas "$(lab_dir 03)"
    # Duas mudanças sem relação, ainda não adicionadas:
    # 1) corrige erro de digitação no bolo
    sed -i 's/misture devagar/misture devagar, sem bater/' bolo-de-cenoura.md
    # 2) acrescenta ingrediente no brigadeiro
    sed -i 's/^- Chocolate granulado para enrolar$/- Chocolate granulado para enrolar\n- 1 pitada de sal/' brigadeiro.md
  )
}

# ---------------------------------------------------------------------------
# Desafio 4 — Ignorando o que não importa
# ---------------------------------------------------------------------------
gerar_04() {
  (
    criar_base_receitas "$(lab_dir 04)"
    # Um .log que foi versionado por engano (missão extra)
    printf 'INFO 2026-08-30 gerando livro antigo...\n' > antigo.log
    commit_chef "Adiciona script de geração do livro em PDF"
    # Arquivos que não deveriam entrar no repositório
    printf 'DEBUG iniciando conversão\nDEBUG concluído\n' > debug.log
    printf 'ERRO imagem não encontrada\n' > erros.log
    mkdir -p build
    printf '<html><body>Livro de receitas</body></html>\n' > build/livro.html
    printf 'API_KEY=segredo-super-secreto\n' > .env
  )
}

# ---------------------------------------------------------------------------
# Desafio 5 — Detetive do histórico
# ---------------------------------------------------------------------------
gerar_05() {
  (
    local dir; dir="$(lab_dir 05)"
    mkdir -p "$dir"; cd "$dir"
    g init -q -b main
    local ANA="Ana Souza" ANA_E="ana@exemplo.com"
    local BRUNO="Bruno Lima" BRUNO_E="bruno@exemplo.com"
    local CARLA="Carla Mendes" CARLA_E="carla@exemplo.com"
    local DIEGO="Diego Ramos" DIEGO_E="diego@exemplo.com"

    receita_bolo 8 "40,00" 200 > bolo-de-cenoura.md
    receita_brigadeiro > brigadeiro.md
    commit_como "$ANA" "$ANA_E" "Cria o livro de receitas"
    lab_meta_set base "$(g rev-parse HEAD)"

    cat > pao-caseiro.md <<'EOF'
# Pão caseiro

Rende: 2 pães

## Ingredientes

- 1 kg de farinha de trigo
- 2 xícaras de água morna
- 10 g de fermento biológico seco
- 1 colher de sopa de açúcar
- 1 colher de chá de sal

## Modo de preparo

1. Misture o fermento com a água e o açúcar e espere 10 minutos.
2. Acrescente a farinha e o sal e sove por 10 minutos.
3. Deixe crescer por 1 hora, modele e asse a 200 graus por 35 minutos.
EOF
    commit_como "$BRUNO" "$BRUNO_E" "Adiciona receita de pão caseiro"

    sed -i 's/forno a 200 graus/forno a 180 graus/' bolo-de-cenoura.md
    commit_como "$CARLA" "$CARLA_E" "Corrige temperatura do forno do bolo"

    receita_mousse > mousse-de-maracuja.md
    commit_como "$DIEGO" "$DIEGO_E" "Adiciona receita de mousse de maracujá"

    sed -i 's/R\$ 40,00/R$ 45,00/' bolo-de-cenoura.md
    commit_como "$CARLA" "$CARLA_E" "Pequenos ajustes"

    sed -i 's/Rende: 8 porções/Rende: 12 porções/' bolo-de-cenoura.md
    commit_como "$ANA" "$ANA_E" "Ajusta porções"

    printf '\n## Dica\n\nGuarde em pote fechado por até 3 dias.\n' >> brigadeiro.md
    commit_como "$BRUNO" "$BRUNO_E" "Adiciona dica de conservação ao brigadeiro"

    sed -i 's/Bata tudo no liquidificador por 3 minutos./Bata tudo no liquidificador por 3 minutos, até ficar homogêneo./' mousse-de-maracuja.md
    commit_como "$DIEGO" "$DIEGO_E" "Detalha o preparo do mousse"

    cat > README.md <<'EOF'
# Livro de receitas

- Bolo de cenoura
- Brigadeiro
- Pão caseiro
- Mousse de maracujá
EOF
    commit_como "$ANA" "$ANA_E" "Adiciona índice de receitas"

    receita_limonada > limonada.md
    commit_como "$CARLA" "$CARLA_E" "Adiciona receita de limonada"

    printf -- '- Limonada\n' >> README.md
    commit_como "$BRUNO" "$BRUNO_E" "Atualiza índice"

    cat > respostas.txt <<'EOF'
# Detetive do histórico — respostas
# Escreva cada resposta na linha que começa com "R:" e salve o arquivo.

1) Quem alterou o preço sugerido do bolo de cenoura? (nome da pessoa)
R:

2) Em qual commit a receita de pão caseiro entrou? (hash curto do commit)
R:

3) Quantas porções o bolo passou a render depois do commit "Ajusta porções"?
R:
EOF
    commit_como "$ANA" "$ANA_E" "Adiciona folha de respostas"
  )
}

# ---------------------------------------------------------------------------
# Desafio 6 — Desfazendo antes do commit
# ---------------------------------------------------------------------------
gerar_06() {
  (
    criar_base_receitas "$(lab_dir 06)"
    # Arquivo estragado, ainda não adicionado
    printf 'ops\n\napaguei tudo sem querer\n' > bolo-de-cenoura.md
    # Arquivo adicionado por engano
    printf 'Lembrar de comprar cenouras.\nSenha do wifi: batata123\n' > notas-pessoais.md
    g add notas-pessoais.md
  )
}

# ---------------------------------------------------------------------------
# Desafio 7 — Desfazendo depois do commit
# ---------------------------------------------------------------------------
gerar_07() {
  (
    criar_base_receitas "$(lab_dir 07)"
    receita_mousse > mousse-de-maracuja.md
    commit_chef "Adiciona receita de mousse"

    # O bug: troca manteiga por sal no brigadeiro
    receita_brigadeiro sal > brigadeiro.md
    commit_chef "Ajusta ingredientes do brigadeiro"
    lab_meta_set bug "$(g rev-parse HEAD)"

    receita_limonada > limonada.md
    commit_chef "Adiciona receita de limonada"

    cat > pudim.md <<'EOF'
# Pudim de leite

Rende: 8 porções

## Ingredientes

- 1 lata de leite condensado
- 2 latas de leite
- 3 ovos
- 1 xícara de açúcar para a calda

## Modo de preparo

1. Derreta o açúcar até virar caramelo e forre a forma.
2. Bata os demais ingredientes e despeje na forma.
3. Asse em banho-maria a 180 graus por 1 hora.
EOF
    commit_chef "Adiciona receita de pudin"
    lab_meta_set topo "$(g rev-parse HEAD)"
  )
}

# ---------------------------------------------------------------------------
# Desafio 8 — Branch de funcionalidade
# ---------------------------------------------------------------------------
gerar_08() {
  (
    criar_base_receitas "$(lab_dir 08)"
    cat > README.md <<'EOF'
# Livro de receitas

- Bolo de cenoura
- Brigadeiro
- Pão de queijo
EOF
    commit_chef "Adiciona índice de receitas"
    lab_meta_set base "$(g rev-parse HEAD)"
  )
}

# ---------------------------------------------------------------------------
# Desafio 9 — Caminhos que divergem
# ---------------------------------------------------------------------------
gerar_09() {
  (
    criar_base_receitas "$(lab_dir 09)"
    g switch -q -c feature/bebidas
    receita_limonada > bebidas.md
    commit_chef "Adiciona receita de limonada"
    cat >> bebidas.md <<'EOF'

# Suco de laranja

Rende: 2 copos

## Ingredientes

- 6 laranjas

## Modo de preparo

1. Esprema as laranjas e sirva gelado.
EOF
    commit_chef "Adiciona receita de suco de laranja"
    g switch -q main
    printf '\n## Dica\n\nGuarde em pote fechado por até 3 dias.\n' >> brigadeiro.md
    commit_chef "Adiciona dica de conservação ao brigadeiro"
    lab_meta_set base "$(g rev-parse HEAD)"
  )
}

# ---------------------------------------------------------------------------
# Desafio 10 — Guardando para depois
# ---------------------------------------------------------------------------
gerar_10() {
  (
    local dir; dir="$(lab_dir 10)"
    mkdir -p "$dir"; cd "$dir"
    g init -q -b main
    receita_bolo 8 "40,00" 1800 > bolo-de-cenoura.md   # bug: 1800 graus
    receita_brigadeiro > brigadeiro.md
    receita_pao_de_queijo > pao-de-queijo.md
    commit_chef "Cria o livro de receitas"
    lab_meta_set base "$(g rev-parse HEAD)"

    g switch -q -c feature/sopas
    printf '# Sopa de legumes\n\nRende: 6 porções\n\n## Ingredientes\n\n' > sopas.md
    commit_chef "Começa a receita de sopa de legumes"
    lab_meta_set base_sopas "$(g rev-parse HEAD)"

    # Trabalho pela metade, ainda não commitado
    cat >> sopas.md <<'EOF'
- 2 batatas
- 2 cenouras
- 1 cebola
- 1 litro de água
EOF
  )
}

# ---------------------------------------------------------------------------
# Desafio 11 — Resolva o conflito
# ---------------------------------------------------------------------------
gerar_11() {
  (
    criar_base_receitas "$(lab_dir 11)"
    g switch -q -c ajuste-preco
    sed -i 's/R\$ 40,00/R$ 48,00/' bolo-de-cenoura.md
    commit_chef "Reajusta preço do bolo por causa do custo das cenouras"
    lab_meta_set tip_ajuste "$(g rev-parse HEAD)"
    g switch -q main
    sed -i 's/R\$ 40,00/R$ 42,00/' bolo-de-cenoura.md
    commit_chef "Atualiza preço do bolo para a tabela de setembro"
    lab_meta_set base "$(g rev-parse HEAD)"
  )
}

# ---------------------------------------------------------------------------
# Desafios 12 e 13 — remoto simulado (repositório bare local)
# ---------------------------------------------------------------------------

# criar_remoto NN  — cria o bare e um clone em lab_dir NN, já populado.
# A função popular_NN deve estar definida e roda dentro do clone temporário.
criar_remoto() {
  local nn="$1"
  local bare; bare="$(lab_remoto "$nn")"
  local dir; dir="$(lab_dir "$nn")"
  mkdir -p "$REMOTOS_DIR"
  rm -rf "$bare"
  g init -q --bare -b main "$bare"
  local tmp; tmp="$(mktemp -d)"
  (
    cd "$tmp"
    g init -q -b main
    "popular_$nn"
    g remote add origin "$bare"
    g push -q origin main
  )
  rm -rf "$tmp"
  g clone -q "$bare" "$dir"
  ( cd "$dir" && lab_meta_set base "$(g rev-parse HEAD)" )
}

popular_12() {
  cat > cardapio.md <<'EOF'
# Cardápio da semana

- Segunda: bolo de cenoura
- Terça: pão de queijo
- Quarta: brigadeiro
EOF
  cat > avisos.md <<'EOF'
# Avisos da cozinha

- Lavar as mãos antes de começar.
EOF
  commit_chef "Cria o cardápio e os avisos"
}

popular_13() {
  receita_bolo > bolo-de-cenoura.md
  receita_brigadeiro > brigadeiro.md
  receita_pao_de_queijo > pao-de-queijo.md
  commit_chef "Cria o livro de receitas"
}

gerar_12() { criar_remoto 12; }
gerar_13() { criar_remoto 13; }

# ---------------------------------------------------------------------------
# Desafios 14 e 15 — o repositório que o aluno publica no GitHub de verdade
# ---------------------------------------------------------------------------
gerar_14() {
  (
    criar_base_receitas "$(lab_dir 14)"
    cat > README.md <<'EOF'
# Meu livro de receitas

Repositório criado durante o curso de Git.
EOF
    commit_chef "Adiciona README"
    lab_meta_set base "$(g rev-parse HEAD)"
  )
}

# ---------------------------------------------------------------------------
# gerar_lab NN — gera o desafio NN (apaga o que existir)
# ---------------------------------------------------------------------------
gerar_lab() {
  local nn="$1"
  local dir; dir="$(lab_dir "$nn")"
  mkdir -p "$LABS_DIR"
  cd "$LABS_DIR"    # o diretório atual pode ser justamente o que vai ser apagado
  rm -rf "$dir"
  if (( 10#$nn == 12 || 10#$nn == 13 )); then rm -rf "$(lab_remoto "$nn")"; fi
  "gerar_$nn"
}
