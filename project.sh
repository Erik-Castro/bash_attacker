#!/usr/bin/env bash

# Nome: bash_attacker
# Autor: Erik Castro
# Data de Criação: 08/10/2024
# Data de modificação: 08/10/2024
# Decription: Simples script de ataque de negação de
# serviço.
# Versão: 0.0.1-alpha
# # ================================================
# Versões:
# -----------
# Versão 0.0.1-alpha: Código básico implementado.
#
# =====================================================
# Licensa:
# ------------
# Copyright 2024 Erik Castro
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# =====================================================
# AVISO LEGAL:
# ------------
# Este software é uma ferramenta de pesquisa e desenvolvimento em segurança da informação, especificamente projetada para simular ataques de negação de serviço (DoS).
#
# É distribuído sob a licença MIT e seu código fonte está disponível publicamente. No entanto, o uso desta ferramenta deve ser restrito a ambientes de testes autorizados e com o objetivo exclusivo de estudar e compreender vulnerabilidades em sistemas de computação.
#
# O autor não se responsabiliza por qualquer uso indevido ou ilícito deste software, incluindo, mas não se limitando a: ataques a sistemas produtivos, violação de leis e regulamentos, ou danos a terceiros.
#
# Ao utilizar esta ferramenta, o usuário concorda em:
#
#    Cumprir integralmente a Lei Geral de Proteção de Dados (LGPD), especialmente no que diz respeito ao tratamento de dados pessoais.
#    Respeitar a legislação brasileira, em particular o Código Penal, no que se refere aos crimes cibernéticos.
#    Obter todas as autorizações necessárias antes de realizar qualquer teste de penetração ou simulação de ataque.
#    Não direcionar ataques a sistemas ou redes sem autorização expressa.
#
# A distribuição, modificação ou comercialização desta ferramenta sem a devida atribuição de autoria é proibida.
#
# Este software é fornecido "como está", sem qualquer garantia expressa ou implícita.
#

# despeja uma mensagem para a saída de erro padrão com data e hora.
msg_erro() {
    printf "[ERRO]: %s \t %s\n" "$*" "$(date +'%d/%m/%Y %X')" >&2
}

# Mostra a versão atual do software
exibe_versao() {
    echo -n "$(basename $0)"
    grep -w "^# Versão " $0 | tail -n1 | sed 's/^#//g' | cut -d: -f1
}

# valida a entrada de paramêtros
menu_check() {
    local params="$@" # Paramêtros fornecidos

    for param in "${params}"; do
        case "$param" in
        -v | --version)
            exibe_versao
            ;;
        *)
            msg_erro "Paramêtro fornecido: \"$param\", invalido!"
            ;;
        esac
    done
}

menu_check "$@"
