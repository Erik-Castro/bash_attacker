# bash_attacker - Documentação

**Versão atual**: 0.3.1-alpha  
**Autor**: Erik Castro  
**Data de Criação**: 08/10/2024  
**Licença**: MIT

---

## Índice
1. [Introdução](#introdução)
2. [Requisitos](#requisitos)
3. [Instalação](#instalação)
4. [Funcionamento](#funcionamento)
5. [Opções e Parâmetros](#opções-e-parâmetros)
6. [Exemplos de Uso](#exemplos-de-uso)
7. [Licença](#licença)
8. [Aviso Legal](#aviso-legal)
9. [Contribuições](#contribuições)

---

## 1. Introdução

O `bash_attacker` é um script Bash simples que simula um ataque de negação de serviço (DoS). Seu objetivo é realizar um alto volume de requisições a um host específico em uma determinada porta, com suporte a múltiplas threads (processos filhos) para aumentar a taxa de requisições.

Este software foi criado com o propósito de servir como uma ferramenta de pesquisa e aprendizado em segurança da informação. Ele não deve ser utilizado em ambientes produtivos ou em redes sem a devida autorização.

---

## 2. Requisitos

- **Bash**: Versão 4.0 ou superior.
- **Curl**: Necessário para enviar as requisições de rede.
- **Figlet** e **Lolcat**: Utilizados para exibir banners de inicialização e finalização de execução (opcionais).

### Instalação dos requisitos no Ubuntu:

```bash
sudo apt update
sudo apt install figlet lolcat netcat
```

---

## 3. Instalação

Para utilizar o `bash_attacker`, basta clonar o repositório ou baixar o script diretamente e garantir que ele seja executável:

```bash
chmod +x bash_attacker.sh
```

Depois, você pode executá-lo diretamente no terminal.

---

## 4. Funcionamento

O script faz uso de requisições TCP simples para um determinado host e porta, podendo realizar múltiplas requisições simultâneas para simular um ataque de negação de serviço. Cada thread gerada pelo script envia uma requisição ao host alvo utilizando o comando `curl`.

**Fluxo de execução**:
1. O usuário define o host e a porta alvo, junto com outras opções, como o número de threads e o tempo de ataque.
2. O script realiza múltiplas requisições TCP até o final do tempo definido.
3. O número de threads especificado é respeitado, e o ataque continua até que o tempo total seja atingido.

---

## 5. Opções e Parâmetros

### Uso básico:

```bash
./bash_attacker.sh [opções] <host> <porta>
```

### Opções disponíveis:

- **-h, --help**: Exibe uma mensagem de ajuda com instruções de uso.
- **-v, --version**: Mostra a versão atual do script.
- **--change-log**: Exibe o histórico de mudanças e atualizações.
- **--show**: Mostra a licença do software.
- **-p, --port \<porta\>**: Define a porta alvo (padrão: 80).
- **-t, --time \<tempo\>**: Define o tempo de ataque em segundos (padrão: 35).
- **-c, --childs \<n\>**: Define o número de threads simultâneas (padrão: 1).
- **--debug**: Habilita o modo de depuração, exibindo mais detalhes sobre a execução.
**-w, --wait**: define o tempo de espera para completar a requisição
**-H, --headers <chave:valor>** Define o cabeçalho customizado.
**-P, --payload <payload>** Define o payload para a requisição
**-m, --method <método>** Define o método para a requisição

### Parâmetros obrigatórios:
- **\<host\>**: O endereço do host alvo (pode ser um IP ou domínio).
- **\<porta\>**: A porta do serviço alvo (padrão: 80).

---

## 6. Exemplos de Uso

### Ataque simples à porta 80 de um host:

```bash
./bash_attacker.sh localhost 80
```

### Especificando a porta, o tempo de ataque e o número de threads:

```bash
./bash_attacker.sh -p 8080 -t 60 -c 5 localhost
```

### Verificando a versão do software:

```bash
./bash_attacker.sh --version
```

### Exibindo o histórico de versões:

```bash
./bash_attacker.sh --change-log
```

---

## 7. Licença

Este software é distribuído sob a Licença MIT. Veja mais detalhes na seção de licença no início do código-fonte.

---

## 8. Aviso Legal

**IMPORTANTE**: Este software é fornecido exclusivamente para fins educacionais e de pesquisa. O uso inadequado, sem autorização expressa, pode ser ilegal e resultar em consequências legais graves.

**O autor não se responsabiliza por quaisquer danos causados pelo uso indevido deste software**. Ao utilizar o `bash_attacker`, o usuário concorda em:
- Respeitar a legislação vigente, incluindo a Lei Geral de Proteção de Dados (LGPD) e o Código Penal Brasileiro no que se refere a crimes cibernéticos.
- Realizar testes somente em ambientes controlados e com as devidas autorizações.
- Assumir total responsabilidade pelas ações realizadas com o software.

---

## 9. Contribuições

Contribuições são bem-vindas! Caso tenha sugestões, melhorias ou correções, sinta-se à vontade para enviar um pull request ou abrir uma issue no repositório.

