.data
tabuleiro: .word 1, 2, 3, 4, 1, 2, 3, 4, 5, 6, 7, 8, 5, 6, 7, 8
revelado: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
linha_primeira_carta: .asciiz "\nDigite a linha da primeira carta: "
coluna_primeira_carta: .asciiz "\nDigite a coluna da primeira carta: "
linha_segunda_carta: .asciiz "\nDigite a linha da segunda carta: "
coluna_segunda_carta: .asciiz "\nDigite a coluna da segunda carta: "
par_acertado: .asciiz "\nPar encontrado!\n"
par_errado: .asciiz "\nPar nao encontrado\n"
jogo_finalizado: .asciiz "\nTodos os pares foram encontrados. Jogo finalizado."

.text
la $s0, tabuleiro #Endereco base do vetor tabuleiro
la $s1, revelado #Endereco base do vetor revelado
li $s2, 4 #Mumero de linhas
li $s3, 4 #Numero de colunas
mul $s4, $s3, $s2 #Numero de cartas
srl $s4, $s4, 1 #Numero de pares a serem descobertos

loop_jogo:
beq $s4, $zero, fim_jogo

jal display_board

la $a0, linha_primeira_carta
li $v0, 4
syscall
li $v0, 5
syscall
subi $v0, $v0, 1
move  $t0, $v0

la $a0, coluna_primeira_carta
li $v0, 4
syscall
li $v0, 5
syscall
subi $v0, $v0, 1
move $t1, $v0

sll $t8, $t0, 2
add $t8, $t8, $t1
sll $t8, $t8, 2
add $t3, $t8, $s1
li $t1, 1
sw $t1, 0($t3)

jal display_board

la $a0, linha_segunda_carta
li $v0, 4
syscall
li $v0, 5
syscall
subi $v0, $v0, 1
move $t1, $v0

la $a0, coluna_segunda_carta
li $v0, 4
syscall
li $v0, 5
syscall
subi $v0, $v0, 1
move $t4, $v0

sll $t9, $t1, 2
add $t9, $t9, $t4
sll $t9, $t9, 2
add $t4, $t9, $s1
li $t1, 1
sw $t1, 0($t4)

jal display_board

jal verifica_par

j loop_jogo
fim_jogo:
la $a0, jogo_finalizado
li $v0, 4
syscall
li $v0, 10
syscall

verifica_par:

add $t2, $t8, $s0 
lw $t0, 0($t2)
add $t3, $t9, $s0
lw $t1, 0($t3)
bne $t0, $t1, else2
la $a0, par_acertado
li $v0, 4
syscall
subi $s4, $s4, 1

j fim_if2
else2:

la $a0, par_errado
li $v0, 4
syscall
li $t0, 0
add $t2, $t8, $s1
add $t3, $t9, $s1
sw $t0, 0($t2)
sw $t0, 0($t3)

fim_if2:

li $a0, '\n'
li $v0, 11
syscall

jr $ra

fim_verifica_par:

display_board:

li $a0, '\n'
li $v0, 11
syscall

li $t0, 1 #Indice i = 1

li $a0, 32 #$a0 = espaco
li $v0, 11 #Imprimir caractere
syscall

loop_header:
bgt $t0, $s2, fim_loop_header

li $a0, 32 #$a0 = espaco
li $v0, 11 #Imprimir caractere
syscall

move $a0, $t0 #$a0 = i
li $v0, 1 #Imprimir inteiro
syscall

addi $t0, $t0, 1 #i = i  + 1

j loop_header
fim_loop_header:


li $t0, 0
loop_i:
bge $t0, $s2, fim_loop_i

li $a0, '\n'
li $v0, 11
syscall

addi $t0, $t0, 1 #i = i + 1
move $a0, $t0 #$a0 = i
li $v0, 1 #Imprimir inteiro
syscall
subi $t0, $t0, 1 #i = i - 1

li $a0, 32 #$a0 = espaco
li $v0, 11 #Imprimir caractere
syscall

li $t1, 0 #Indice  j = 0
loop_j:
bge $t1, $s3, fim_loop_j

sll $t2, $t0, 2 #$t2 = i * 4
add $t2, $t2, $t1 #$t2 = $t2 + j
sll $t2, $t2, 2 #$t2 = $t2 * 4
add $t2, $t2, $s1 #Endere�o base do vetor revelado mais deslocamento
lw $t3, 0($t2) #$t3 = revelado[$t2]

#if(revelado[$t2] == 0)
bne $t3, $zero, else
li $a0, '*'
li $v0, 11
j fim_if
else:
sub $t2, $t2, $s1
add $t2, $t2, $s0
lw $a0, 0($t2) #$a0 = tabuleiro[$t2]
li $v0, 1 #Imprimir inteiro
fim_if:

syscall

li $a0, 32 #$a0 = espaco
li $v0, 11 #Imprimir caractere
syscall

addi $t1, $t1, 1 #j = j + 1
j loop_j
fim_loop_j:

addi $t0, $t0, 1 #i = i + 1
j loop_i
fim_loop_i:

li $a0, '\n'
li $v0, 11
syscall

jr $ra
fim_display_board:
