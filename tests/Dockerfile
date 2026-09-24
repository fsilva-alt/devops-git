# Ambiente de teste que imita um Codespace em branco: Ubuntu, usuário não-root,
# git instalado e nada do curso. O instalador é quem monta tudo.
FROM ubuntu:24.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends git ca-certificates zsh \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash aluno

USER aluno
WORKDIR /home/aluno
RUN touch /home/aluno/.zshrc
