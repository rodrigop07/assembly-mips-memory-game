# Jogo da Memória em MIPS Assembly

![Static Badge](https://img.shields.io/badge/Assembly-MIPS-blue?style=for-the-badge&logo=assemblyscript)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)


Este repositório contém uma implementação do clássico **Jogo da Memória** desenvolvida inteiramente em **MIPS Assembly**. O jogo é executado via console de Entrada/Saída (E/S), apresentando uma grade interativa de 4x4 elementos onde o jogador deve encontrar todos os pares de números correspondentes.

---

## Regras e Funcionamento

1. **Tabuleiro:** Consiste em uma matriz 4x4 com 16 cartas no total.
2. **Cartas Ocultas:** São exibidas no console como asteriscos (`*`).
3. **Cartas Reveladas:** Mostram o número correspondente (valores de `1` a `8`).
4. **Turnos do Jogador:**
   - Em cada jogada, o console solicitará a **linha** (1 a 4) e a **coluna** (1 a 4) da primeira carta.
   - O tabuleiro será exibido com a primeira carta revelada.
   - Em seguida, o jogador insere a **linha** e a **coluna** da segunda carta.
   - O tabuleiro será reexibido com ambas as cartas reveladas.
5. **Verificação de Par:**
   - **Caso os valores sejam iguais:** O sistema exibe `"Par encontrado!"` e as cartas permanecem reveladas definitivamente.
   - **Caso os valores sejam diferentes:** O sistema exibe `"Par não encontrado"` e as duas cartas retornam ao estado oculto (`*`) para a próxima rodada.
6. **Fim de Jogo:** A partida encerra quando todos os 8 pares forem encontrados com sucesso.

---

## Detalhes Técnicos e Arquitetura do Código

A arquitetura do jogo é estruturada da seguinte forma:

### 1. Seção de Dados (`.data`)
* **`tabuleiro`**: Vetor de 16 palavras (`.word`) contendo os valores predefinidos que serão pareados: `1, 2, 3, 4, 1, 2, 3, 4, 5, 6, 7, 8, 5, 6, 7, 8`.
* **`revelado`**: Vetor de 16 palavras contendo bits indicadores (`0` para oculto, `1` para revelado) que determinam o estado visual do tabuleiro.
* **Mensagens e Prompts**: Strings ascii terminadas em nulo (`.asciiz`) para interação com o usuário através de chamadas de sistema (syscalls).

### 2. Fluxo de Execução (`.text`)

O código executa um ciclo contínuo baseado nas seguintes etapas:
* **`loop_jogo`**: Controla o estado global do jogo. Se o contador de pares restantes chegar a `0`, salta para `fim_jogo`.
* **`display_board`**: Atualiza e exibe graficamente a grade no console com os índices numéricos das linhas e colunas. Verifica o vetor `revelado` para decidir se exibe `*` ou o número real de `tabuleiro`.
* **`verifica_par`**: Compara os valores correspondentes dos índices calculados para as duas cartas escolhidas.
  - A conversão de índices do jogador (linha e coluna) para offset de memória de vetor unidimensional 1D é dada pela fórmula clássica:
    $$\text{Offset} = ((\text{linha} - 1) \times 4 + (\text{coluna} - 1)) \times 4 \text{ bytes}$$

#### Mapeamento de Registradores Principais:
* `$s0`: Endereço base do vetor `tabuleiro`.
* `$s1`: Endereço base do vetor `revelado`.
* `$s2`: Número de linhas da grade (iniciado em `4`).
* `$s3`: Número de colunas da grade (iniciado em `4`).
* `$s4`: Número de pares a serem descobertos (iniciado em `8`).

---

## Como Executar o Jogo

O código foi projetado para ser executado em simuladores de arquitetura MIPS, como o **MARS (MIPS Assembler and Runtime Simulator)** ou o **SPIM**.

### Passo a Passo no MARS Simulator:
1. Certifique-se de possuir o Java instalado em sua máquina.
2. Faça o download do executável jar do simulator na página oficial do [MARS Simulator](https://courses.missouristate.edu/kenvollmar/mars/).
3. Execute o simulador MARS.
4. Vá em **File > Open...** e selecione o arquivo `projeto.asm`.
5. Pressione **F3** ou vá no menu superior **Run > Assemble** para montar o código.
6. Pressione **F5** ou selecione **Run > Go** para iniciar o jogo.
7. Visualize e interaja no painel inferior **Run I/O** inserindo os dados solicitados.

---

## Demonstração de Jogabilidade (Console)

```text
  1 2 3 4
1 * * * *
2 * * * *
3 * * * *
4 * * * *

Digite a linha da primeira carta: 1
Digite a coluna da primeira carta: 1

  1 2 3 4
1 1 * * *
2 * * * *
3 * * * *
4 * * * *

Digite a linha da segunda carta: 1
Digite a coluna da segunda carta: 2

  1 2 3 4
1 1 2 * *
2 * * * *
3 * * * *
4 * * * *

Par não encontrado

  1 2 3 4
1 * * * *
2 * * * *
3 * * * *
4 * * * *
```
