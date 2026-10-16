# Nomes: João Miguel Oliveira de Carvalho
# Data: 16/10/2026
# Atividade: 1 VA
# Disciplina: Arquitetura e Organização de Computadores
# Semestre: 2026.2

# Descrição do projeto:
#	- Sistema de cadastro de pessoas e automóveis em um condomínio
#	- O Condomínio possui 12 andares, cada andar com 2 apartamentos (APs)
#	- Cada AP deve ter no máximo 6 pessoas
#	- Cada Ap deve ter somente no máximo 1 carro ou 2 motos (nunca os dois)
#	- Os dados devem ser salvos em um arquivo ("dados.txt")
#	- Cada comando digitado é finalizado com "\n" e precedido por um banner ("SAHJ-shell>> ")
#	- Cada argumento passado deve ser precedido por " --"
#	- O Sistema deve ser capaz de diferenciar um AP vazio de um não vazio
#	- Comandos:
#		- addMorador --<option1> --<option2> 				// addMorador --1102 --Claude Shannon
#		- rmvMorador --<option1> --<option2>				// rmvMorador --1102 --Claude Shannon
#		- AddAuto --<option1> --<option2> --<option3> --<option4>	// addAuto --303 --c --Fiat Uno --ABC1234
#		- rmvAuto --<option1> --<option2>				// rmvAuto --303 --ABC1234
#		- limparAp --<option1>						// limparAp --1001
#		- infoAp --<option1>						// infoAp --1001
#		- infoGeral
#		- salvar
#		- recarregar
#		- formatar

# Seção de dados
.data
	# Textos e mensagens
	banner:		.asciiz "SAHJ-shell>> "
	quebra_linha:	.asciiz "\n"
	
	# Buffers
	buffer:		.space	501	# Buffer principal
	cmd_main:	.space	64	# Buffer para o comando principal
	cmd_option1:	.space 	64	# Buffer para o argumento 1
	cmd_option2:	.space 	64	# Buffer para o argumento 2
	cmd_option3:	.space 	64	# Buffer para o argumento 3
	cmd_option4:	.space 	64	# Buffer para o argumento 4
	
	# Tabela de APs
	# Estrutura do AP
	#	- 0 - 383 (384 bytes para os nomes dos moradores [64 bytes para no máximo 6 pessoas])
	#	- 384	(1 bytes para o status do apartamento [0 - Vazio, 1 - Não Vazio])
	#	- 385 - 386 (2 bytes para endereçar o número do AP [101, 102, 201, 202, ... , 1201, 1202])
	#	- 387 (1 byte para o tipo do automóvel [0 - Nenhum, c - Carro, m - Moto])
	#	- 388 (1 byte para quantidade de veículos [1 carro ou no máximo 2 motos])
	#	- 388 - 535 (74 bytes para registrar modelo e placa (caso carro) ou 148 bytes (caso 2 motos))
	# Total de bytes por AP: 536 bytes
	# Total para os 12 andares = 536 * 24 = 12864 bytes
	main_memory: 	.space 12864

# -------------------------------------------------------
# Código Principal
# -------------------------------------------------------

.text
.globl main

main:
	# Recarregar dados do arquivo para o programa

# Loop principal
main_loop:
	# Escreve o banner na tela
	li $v0, 4
	la $a0, banner
	syscall
	
	# Lê entrada do usuário
	li $v0, 8
	la $a0, buffer
	li $a1, 501
	syscall
	
	# Executar o parser para separar o comando e os argumentos em buffers
	jal cmd_parser
	
	# Teste de dispacher
	
	# Volta para o loop
	j main_loop
	
# -------------------------------------------------------
# Funcionalidades
# -------------------------------------------------------

cmd_parser:
	# 1º Ler e guardar o comando principal
	# Guardar registradores
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	
	# Limpar buffers
	la $a0, cmd_main
	li $a1, 64
	jal limpar_buffer
	la $a0, cmd_option1
	li $a1, 64
	jal limpar_buffer
	la $a0, cmd_option2
	li $a1, 64
	jal limpar_buffer
	la $a0, cmd_option3
	li $a1, 64
	jal limpar_buffer
	la $a0, cmd_option4
	li $a1, 64
	jal limpar_buffer
	
	# Retorna argumentos originais
	lw $a0, 4($sp)
	
	# Argumento principal
	move $s0, $a0 	# Endereço do buffer principal
	la $s1, cmd_main # Endereço do buffer do comando principal

cmd_parser_loop:
	lb $t2, 0($s0)	# Carrega o byte em $t2
	beq $t2, 10, parser_done	# Finaliza o parser ao encontrar "\n"
	beq $t2, 0, parser_done		# Finaliza o parser ao encontrar "\0"
	beq $t2, 32, parser_main_done	# Passa para a parte de armazenar argumentos
	
	# Carrega o byte no cmd_main
	sb $t2, 0($s1)
	
	# Incrementa registradores
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	
	# Volta para o loop
	j cmd_parser_loop

parser_main_done:
	sb $zero, 0($s1)	# Adiciona terminador nulo em cmd_main
	
	# Inicializa ponteiro para a primeira opção e o contador de argumentos (1 a 4)
	la $t3, cmd_option1 	# Endereço do buffer da option1
	li $s4, 1		# Inicia o contador

find_option_loop:
	lb $t2, 0($s0)
	beq $t2, 10, parser_done	# Finaliza parser
	beq $t2, 0, parser_done		# Finaliza parser
	
	# Procurar pelo "--"
	bne $t2, 45, next_char_search # Verifica se é um "-"
	lb $t4, 1($s0)
	bne $t4, 45, next_char_search # Verifica se o próximo também é "-"
	
	addi $s0, $s0, 2 	# Passaram por 2 hífens

# Pula espaço em branco
skip_opt_spaces:
	lb $t2, 0($s0)
	beq $t2, 32, adv_opt_space
	beq $t2, 9, adv_opt_space 	# Tabulação (opcional)
	j copy_option_chars

adv_opt_space:
	addi $s0, $s0, 1
	j skip_opt_spaces

copy_option_chars:
	lb $t2, 0($s0)
	beq $t2, 0, save_and_finish
	beq $t2, 10, save_and_finish
	
	# Verificar se encontramos um novo separador "--" inline
	beq $t2, 45, check_inline_hypen
	
	sb $t2, 0($t3)	# Guarda o caractere no buffer da opção atual
	
	# Incrementa
	addi $s0, $s0, 1
	addi $t3, $t3, 1
	j copy_option_chars

check_inline_hypen:
	lb $t4, 1($s0)
	beq $t4, 45, save_option_end	# Inicia novo argumento
	
	# Se não for, trata-se de um hífen normal
	sb $t2, 0($t3)
	
	# Incrementa
	addi $s0, $s0, 1
	addi $t3, $t3, 1
	j copy_option_chars

save_option_end:
	sb $zero, 0($t3)	# Fecha a string do buffer atual com "\0"
	
	# Alternar para o próximo buffer
	addi $s4, $s4, 1
	beq $s4, 2,set_opt2
	beq $s4, 3,set_opt3
	beq $s4, 4,set_opt4
	j parser_done	# Caso todas as options tenham sido testadas

set_opt2:
	la $t3, cmd_option2
	j find_option_loop

set_opt3:
	la $t3, cmd_option3
	j find_option_loop

set_opt4:
	la $t3, cmd_option4
	j find_option_loop

save_and_finish:
	sb $zero, 0($t3)	# Garante que o último option analisado fique com "\0"

	j parser_done

next_char_search:
	addi $s0, $s0, 1
	j find_option_loop

parser_done:
	# Alinha pilha
	lw $ra, 0($sp)
	addi $sp, $sp, 8	
	
	jr $ra # Retorna para a main





# -------------------------------------------------------
# Funções auxiliares
# -------------------------------------------------------

# Função: memcpy (destination, source, num)
# Função usada para copiar bytes de source dentro de destination
# $a2 -> Número de bytes a ser copiados
# $a1 -> Endereço do source
# $a0 -> Endereço do destination

memcpy:
	# Copia endereços para registradores temporários
	add $t2, $0, $a2 # Num
	add $t0, $0, $a1 # Source
	add $t1, $0, $a0 # Destination
	xor $t4, $t4, $t4 # Contador
	
	loop_memcpy:
		# Testa se chegou no número de bytes escolhidos para copiar
		beq $t4, $t2, exit_memcpy
	
		# Carrega o byte
		lb $t3, 0($t0)
		# Salva o byte no buffer do destination
		sb $t3, 0($t1)
	
		# Incrementa
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		addi $t4, $t4, 1
	
		# Volta o loop
		j loop_memcpy
	
	exit_memcpy:		
		add $v0, $0, $a0
		
		# Endereço de retorno
		# Volta para o main
		jr $ra

# Função: strcmp (str1, str2)
# Função usada para comparar o as duas strings
# $a1 -> Endereço de memória de str2
# $a0 -> Endereço de memória de str1

strcmp:
	# Copia endereços para registradores temporários
	add $t0, $0, $a0 # str1
	add $t1, $0, $a1 # str2
	
	# Carrega o primeiro caractere de str1
	lb $t2, 0($t0)
	
	# Carrega o primeiro caractere de str2
	lb $t3, 0($t1)
	
	
	
	loop_strcmp:
		# Subtrai os dois caracteres para ver se são iguais
		sub $t5, $t2, $t3
	
		# Caso a subtração seja diferente de 0 logo $t2 != $t3
		bne $t5, $0, exit_strcmp
	
		# Testa se chegou no último caractere '\0' em str1
		beq $t2, $0, exit_strcmp
		# Testa se chegou no último caractere '\0' em str2
		beq $t3, $0, exit_strcmp
	
		# Incrementa
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		
		# Próximo caractere de str1
		lb $t2, 0($t0)
		
		# Próximo caractere de str2
		lb $t3, 0($t1)
		
	
		# Volta o loop
		j loop_strcmp
	
	exit_strcmp:
		# $t5 < 0 -> o caractere diferente possui valor decimal menor em str 1
		# $t5 == 0 -> str1 é igual a str2
		# $t5 > 0 -> o caractere diferente possui valor decimal maior em str 1
		add $v0, $0, $t5
		
		# Endereço de retorno
		# Volta para o main
		jr $ra

# Função: limpar_buffer (buffer, num)
# Função usada para zerar num bytes dentro do buffer
# $a1 -> Número de bytes
# $a0 -> Endereço de memória do buffer

limpar_buffer:
	# Inicializa os registradores
	move $t0, $a0 	# Endereço do buffer
	li $t1, 0	# Contador de bytes
	move $t2, $a1 	# Total de bytes

limpar_buffer_loop:
	# Verifica se chegou no final do buffer
	beq $t1, $t2, limpar_buffer_end
	
	# Limpa byte atual
	sb $zero, 0($t0)
	
	# Incrementa
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	
	# Volta do loop
	j limpar_buffer_loop

limpar_buffer_end:
	# Volta para a função anterior
	jr $ra








