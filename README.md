# Bash Attacker

Versão: 0.4.1-alpha  
Autor: Erik Castro  
Data de Criação: 08/10/2024

## Descrição

O Bash Attacker é uma ferramenta simples de ataque de negação de serviço (DoS) desenvolvida em Bash. Seu objetivo principal é auxiliar em estudos e simulações de segurança cibernética, permitindo que ataques DoS sejam executados em ambientes controlados e autorizados.

⚠️ Aviso Legal: Este software é destinado unicamente para fins educacionais e de pesquisa, sendo proibido o uso sem autorização em sistemas produtivos ou redes de terceiros. O autor não se responsabiliza por qualquer uso inadequado da ferramenta.

## Requisitos

- bash (>= 4.0)
- Curl (para as requisições)
- figlet e lolcat (opcionais, para exibição de banners)

## Funcionalidades

- Ataque DoS simples utilizando requisições HTTP enviadas via netcat.
- Suporte para múltiplos processos simultâneos (threads).
- Personalização de parâmetros como tempo de ataque, porta alvo e número de threads.

## Como Usar

### Sintaxe

bash_attacker [opções] <host> <porta>
### Parâmetros

| Opção              | Descrição                                               |
|--------------------|---------------------------------------------------------|
| -p, --port      | Define a porta alvo (padrão: 80)                        |
| -t, --time      | Define o tempo de ataque em segundos (padrão: 35)       |
| -c, --childs    | Define o número de processos simultâneos (padrão: 1)    |
| -d, --debug     | Habilita o modo debug                                   |
| -h, --help      | Exibe a ajuda                                           |
| --change-log      | Exibe o histórico de mudanças                           |
| --show            | Exibe a licença                                         |
| -v, --version   | Exibe a versão do software                              |
| -w, --wait      | Define o tempo de espera para completar a requisição  |
| -H, --headers   | Define cabeçalhos customizado no formato 'Chave=valor' |
| -m, --method    | Definine o método de requisição |
| -P, --payload   | Define o payload da requisição |


### Exemplo de Uso

bash_attacker -p 8080 -t 60 -c 5 <host_alvo>
Este comando executa um ataque DoS simples no host especificado, direcionado à porta 8080, com duração de 60 segundos e utilizando 5 threads simultâneas.

## Histórico de Versões

- Versão 0.0.1-alpha: Código básico implementado.
- Versão 0.3.1-alpha: Melhorias na forma de requisição
- Versão 0.4.0-alpha: Implementação de cabeçalhos e metodos de requisições customizadas

## Licença

Este software é licenciado sob a [Licença MIT](https://opensource.org/licenses/MIT). Consulte o arquivo do código para mais detalhes sobre os termos de uso.
