# Nomes: João Miguel Oliveira de Carvalho, Alicia Maria de S. M. Gomes
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
#		- addAuto --<option1> --<option2> --<option3> --<option4>	// addAuto --303 --c --Fiat Uno --ABC1234
#		- rmvAuto --<option1> --<option2>				// rmvAuto --303 --ABC1234
#		- limparAp --<option1>						// limparAp --1001
#		- infoAp --<option1>						// infoAp --1001
#		- infoGeral
#		- salvar
#		- recarregar
#		- formatar
#		- help
#		- exit

# Seção de dados
.data
	# Textos e mensagens
	banner:		.asciiz "SAHJ-shell>> "
	quebra_linha:	.asciiz "\n"
	erro_msg:	.asciiz "Comando invalido\n"
	nome_arquivo:	.asciiz "dados.txt"
	msg_save:	.asciiz "Alterações salvas com sucesso!\n"
	titulo:		.asciiz "------------------------------\n      SISTEMA CONDOMINIO      \n------------------------------\n\n"
	help_rsp:	.asciiz "\n------------------------------------------------------------------------------------------------------------------------\n                                                   COMANDOS DO SISTEMA                                                  \n------------------------------------------------------------------------------------------------------------------------\n\n\t- addMorador --<option1> --<option2>\n\t\t// <option1>: Numero do apartamento (ex: 101 a 1202)\n\t\t// <option2>: Nome completo do morador a ser adicionado (max: 6 por AP)\n\n\t- rmvMorador --<option1> --<option2>\n\t\t// <option1>: Numero do apartamento\n\t\t// <option2>: Nome do morador a ser removido\n\n\t- addAuto --<option1> --<option2> --<option3> --<option4>\n\t\t// <option1>: Numero do apartamento\n\t\t// <option2>: Tpo do veiculo ('c' para Carro [max 1] ou 'm' para Moto [max 2])\n\t\t// <option3>: Modelo do veiculo (ex: Fiat Uno)\n\t\t// <option4>: Placa do veiculo (ex: ABC1234)\n\n\t- rmvAuto --<option1> --<option2>\n\t\t// <option1>: Numero do apartamento\n\t\t// <option2>: Placa do veiculo a ser removido\n\n\t- limparAp --<option1>\n\t\t// <option1>: Numero do apartamento cujos dados serao apagados da memoria\n\n\t- infoAp --<option1>\n\t\t// <option1>: Numero do apartamento para exibir detalhes (moradores e veiculos)\n\n\t- infoGeral\n\t\t// Exibe estatisticas gerais do condominio (porcentagem de APs ocupados/vazios)\n\n\t- salvar\n\t\t// Salva os dados atuais contidos na memoria RAM para o arquivo 'dados.txt'\n\n\t- recarregar\n\t\t// Carrega e atualiza a memoria RAM com os dados salvos em 'dados.txt'\n\n\t- formatar\n\t\t// Limpa todos os dados da memoria RAM (nao altera o arquivo no disco)\n\n\t- help\n\t\t// Exibe esta lista de comandos do sistema\n\n\t- exit\n\t\t// Permitir sair do programa principal e salvar os dados\n\n------------------------------------------------------------------------------------------------------------------------\n\n"
	apt_invalido:   .asciiz "Falha: AP invalido\n"
	apt_lotado:     .asciiz "Falha: AP com numero max de moradores\n"
	nome_vazio:	.asciiz "Falha: Nome vazio\n"
	save_conf_msg:		.asciiz "Deseja salvar as alteracoes? [S/N]: " 	# Mensagem de confirmação de salvamento
	err_conf_msg:		.asciiz "Caractere invalido! Por favor digite apenas 'S' ou 'N'!\n"
	form_conf_msg:		.asciiz "Deseja apagar todos os dados do programa atual? [S/N]: "
	nEncontrado:	.asciiz "Falha: morador nao encontrado\n"
	
	# Mensagens do infoAp / infoGeral
	msg_ap:			.asciiz "AP: "			# Prefixo do cabeçalho: "AP: 101"
	msg_ap_vazio:		.asciiz "Apartamento vazio\n"	# Texto exibido quando o AP não tem moradores
	msg_moradores:		.asciiz "Moradores:\n"		# Título da lista de moradores
	msg_carro:		.asciiz "Carro:\n"		# Título da seção de carro
	msg_moto:		.asciiz "Moto:\n"		# Título da seção de motos
	msg_tab:		.asciiz "\t"			# Recuo antes de cada linha de veículo
	msg_barra:		.asciiz " / "			# Separador entre modelo e placa
	msg_nao_vazios:		.asciiz "Nao vazios: "		# Rótulo da linha de APs não vazios
	msg_vazios:		.asciiz "Vazios:     "		# Rótulo da linha de APs vazios 
	msg_abre_par:		.asciiz " ("			# Abre o parêntese 
	msg_fecha_par:		.asciiz "%)\n"			# Fecha o parêntese, mostra % e quebra a linha
	
	
	# Comandos
	cmd_addMorador:	.asciiz "addMorador"		# Comando para adicionar morador
	cmd_rmvMorador:	.asciiz "rmvMorador"		# Comando para remover morador
	cmd_addAuto:	.asciiz "addAuto"		# Comando para adicionar automóvel
	cmd_rmvAuto:	.asciiz "rmvAuto"		# Comando para remover automóvel
	cmd_limparAp:	.asciiz "limparAp"		# Comando para apagar dados AP da memória
	cmd_infoAp:	.asciiz "infoAp"		# Comando para ver informações do AP
	cmd_infoGeral:	.asciiz "infoGeral"		# Comando para ver informações gerais sobre os AP
	cmd_salvar:	.asciiz "salvar"		# Comando para salvar dados da memória do programa no arquivo "dados.txt"
	cmd_recarregar:	.asciiz "recarregar"		# Comando para carregar dados do arquivo "dados.txt" na memória
	cmd_formatar:	.asciiz "formatar"		# Comando para apagar todos os dados da memória do programa
	cmd_help:	.asciiz "help"			# Comando para listar todos os comandos do sistema
	cmd_exit:	.asciiz "exit"			# Comando para sair do sistema
	
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
	#	- 384 (1 bytes para o status do apartamento [0 - Vazio, 1 - Não Vazio])
	#	- 385 (1 byte para o número de pessoas [máx 6])
	#	- 386 - 387 (2 bytes para endereçar o número do AP [101, 102, 201, 202, ... , 1201, 1202])
	#	- 388 (1 byte para o tipo do automóvel [0 - Nenhum, c - Carro, m - Moto])
	#	- 389 (1 byte para quantidade de veículos [1 carro ou no máximo 2 motos])
	#	- 390 - 535 (74 bytes para registrar modelo e placa (caso carro) ou 148 bytes (caso 2 motos))
	# Total de bytes por AP: 537 bytes
	# Total para os 12 andares = 537 * 24 = 12888 bytes
	max_main_memory: .word 12888	# Caso queira alterar o tamanho da memória
	main_memory: 	.space 12888

# -------------------------------------------------------
# Código Principal
# -------------------------------------------------------

.text
.globl main

main:
	# Exibir título de boas vindas
	li $v0, 4		# Syscall para escrever string
	la $a0, titulo		# titulo a ser exibido
	syscall
	
	# Verificar se o arquivo .txt já existe ou precisa ser criado (a fazer)
	# Recarregar os últimos dados do arquivo para o programa
	j recarregar

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
	
	# Teste de dispatcher
	
	# Se for o 1º comando: addMorador
	la $a0, cmd_main
	la $a1, cmd_addMorador
	jal strcmp
	beq $v0, $zero, addMorador
	
	# Se for o 2º comando: rmvMorador
	la $a0, cmd_main
	la $a1, cmd_rmvMorador
	jal strcmp
	beq $v0, $zero, rmvMorador
	
	# Se for o 3º comando: addAuto
	la $a0, cmd_main
	la $a1, cmd_addAuto
	jal strcmp
	beq $v0, $zero, addAuto
	
	# Se for o 4º comando: rmvAuto
	la $a0, cmd_main
	la $a1, cmd_rmvAuto
	jal strcmp
	beq $v0, $zero, rmvAuto
	
	# Se for o 5º comando: limparAp
	la $a0, cmd_main
	la $a1, cmd_limparAp
	jal strcmp
	beq $v0, $zero, limparAp
	
	# Se for o 6º comando: infoAp
	la $a0, cmd_main
	la $a1, cmd_infoAp
	jal strcmp
	beq $v0, $zero, infoAp
	
	# Se for o 7º comando: infoGeral
	la $a0, cmd_main
	la $a1, cmd_infoGeral
	jal strcmp
	beq $v0, $zero, infoGeral
	
	# Se for o 8º comando: salvar
	la $a0, cmd_main
	la $a1, cmd_salvar
	jal strcmp
	beq $v0, $zero, salvar
	
	# Se for o 9º comando: recarregar
	la $a0, cmd_main
	la $a1, cmd_recarregar
	jal strcmp
	beq $v0, $zero, recarregar
	
	# Se for o 10º comando: formatar
	la $a0, cmd_main
	la $a1, cmd_formatar
	jal strcmp
	beq $v0, $zero, formatar
	
	# Se for o 11º comando: help
	la $a0, cmd_main
	la $a1, cmd_help
	jal strcmp
	beq $v0, $zero, help
	
	# Se for o 12º comando: exit
	la $a0, cmd_main
	la $a1, cmd_exit
	jal strcmp
	beq $v0, $zero, exit
	
	# Caso não seja nenhum dos comandos acima, logo o comando está inválido
	li $v0, 4
	la $a0, erro_msg
	syscall
	
	
	# Volta para o loop
	j main_loop
	
# -------------------------------------------------------
# Parser do terminal
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
# Comandos a serem implementados
# -------------------------------------------------------

addMorador:
	# Adiciona um morador a um AP
	# 1 Verificar se os buffer option2 esta vazio
	la $t0, cmd_option2 #guarda a string
	lb $t1, 0($t0) # pega o primeiro caracter
	beq $t1, 0, nExiste #verifica se o nome esta vazio
	beq $t1, 10, main_loop #se deu apenas enter, volta pro loop
	
	# 2 Verificar se o numero do AP existe
	jal existeApt #verifica se o apt existe
	bltz $v0, main_loop #caso nao, volta para o main
	
	# 3 Verificar se o numero maximo de pessoas foi atingido
	move $s0, $v0 #salva o endereco do apt
	lb $t2, 385($s0) #pega o byte dos moradores
	beq $t2, 6, lotado #verifica se esta lotado
	
#$t2 guarda o byte de moradores
#contador 6 vezes
addi $t3, $0, 0 #contador
move $t4, $s0 #copia para um registrador temporario
achaApt: #achar um byte livre para guardar o morador
	beq $t3, 6, lotado #compara o contador
	lb $t1, 0($t4) #pega o byte  
	beq $t1, 0, guardar #verifica se esta vazio
	addi $t4, $t4, 64 #avanca para o proximo slot
	addi $t3, $t3, 1 #adiciona o contador
	j achaApt #volta o loop
	
guardar:
	la $a1, cmd_option2 #manda a string de cmd_option2
	move $a0, $t4 #guarda no slot de moradores
	jal strcpy #copia
	lb $t2, 385($s0) #pega o byte dos moradores
	addi $t2, $t2, 1 #+1 no byte de quantidade de moradores
	sb $t2, 385($s0) # grava a nova quantidade de moradores
	addi $t5, $0, 1
	sb $t5, 384($s0) #pega o byte de status do apartamento
	j main_loop
	
lotado: 
	li $v0, 4 # Syscall para escrever string
	la $a0, apt_lotado #imprime a mensagem de falha
	syscall	
	addi $v0, $0, -1 #manda para o retorno a falha
	j main_loop
	
	# Volta para a main
	j main_loop

nExiste:
	li $v0, 4 # Syscall para escrever string
	la $a0, nome_vazio #imprime a mensagem de falha
	syscall	
	addi $v0, $0, -1 #manda para o retorno a falha
	j main_loop

rmvMorador:
	# Remove um morador de um AP
	# 1 Verificar se o buffer option2 nao esta vazio
	la $t0, cmd_option2 #guarda a string
	lb $t1, 0($t0) # pega o primeiro caracter
	beq $t1, 0, nExiste #verifica se o nome esta vazio
	beq $t1, 10, main_loop #se deu apenas enter, volta pro loop
	
	# 2 Verificar se o numero do AP existe
	jal existeApt #verifica se o apt existe
	bltz $v0, main_loop #caso nao, volta para o main
	
	# 3 Verificar se o apt possui moradores
	move $s0, $v0 #salva o endereco do apt
	lb $s1, 385($s0) #pega o byte dos moradores
	beq $s1, 0, n_encontra_morador #verifica se esta vazio
	
	# 4 Verificar se o nome da pessoa existe no AP
addi $s2, $0, 0 #contador
move $s3, $s0 #copia para outro registrador 
#$s1=$t2
#$s2=$t3
#$s3=$t4
buscaMorador:
	beq $s2, 6, n_encontra_morador #compara o contador
	lb $t1, 0($s3) #pega o byte  
	bnez $t1, compara #verifica se esta vazio
	addi $s3, $s3, 64 #avanca para o proximo slot
	addi $s2, $s2, 1 #adiciona o contador
	j buscaMorador #volta o loop

#verifica se o morador encontrado eh o mesmo de option2 
compara:
	la $a0, cmd_option2 # copia para $a0 o nome encontrado
	move $a1, $s3 #copia para $a1 o nome desejado
	jal strcmp #verifica se sao iguais
	beqz $v0, remocao #caso sim, vai ser removido

addContador: #caso nao, adiciona no contador e no ponteiro
	addi $s3, $s3, 64 #avanca para o proximo slot
	addi $s2, $s2, 1 #adiciona o contador
	j buscaMorador #volta o loop
	
	# 5 remover e atualizar os bytes
remocao:
	move $a0, $s3 # Endereco do slot de 64 bytes do morador encontrado
	li $a1, 64 # tamanho do slot 
	jal limpar_buffer # zera os 64 bytes do morador
	
decrementa:
	addi $s1, $s1, -1 # diminui 1 da quantidade de moradores
	sb $s1, 385($s0) # grava a nova quantidade de moradores no byte 385
	beqz $s1, vazio # se chegou a 0 moradores, vai para vazio
	j main_loop # se nao, volta para o menu

vazio:
	sb $0, 384($s0) # grava a nova quantidade de moradores
	addi $a0, $s0, 388 # endereco onde comecam os dados de automoveis
	li $a1, 148 # total de bytes dos automoveis
	jal limpar_buffer # apaga tudo dos automoveis
	j main_loop
	
n_encontra_morador:
	li $v0, 4 # Syscall para escrever string
	la $a0, nEncontrado #imprime a mensagem de falha
	syscall	
	addi $v0, $0, -1 #manda para o retorno a falha
	j main_loop

addAuto:
	# Adiciona um automóvel a um AP
	# 1º Verificar se os buffers option1, option2, option3, option4 não estão vazios
	# 2º Verificar se o número do AP existe
	# 3º Verificar se o automóvel existe no AP
	# 4º Verificar se o número pessoas é maior que zero
	# 5º Verificar qual o tipo de automóvel
	# 6º Verificar a quantidade de automóveis
	# 7º Calcular o endereço de memória no AP
	# 8º Salvar o automóvel no respectivo endereço
	
	# Volta para a main
	j main_loop

rmvAuto:
	# Remove um automóvel de um AP
	# 1º Verificar se os buffers option1 e option2 não estão vazios
	# 2º Verificar se o número do AP existe
	# 3º Verificar se o automóvel existe no AP
	# 4º Calcular o endereço de memória no AP
	# 5º Remover o automóvel no respectivo endereço
	# 6º Atualizar o número de automóveis
	
	# Volta para a main
	j main_loop

limparAp:
	# Apaga dados do AP na memória
	
	# 1º Verificar se o número do AP existe (existeApt já trata option 1 vazia)
	
	jal existeApt # Converte option1 no endereço do AP ($v0) ou devolve -1
	bltz $v0, main_loop # AP inválido: existeApt já imprimmiu a mensagem de falha
	
	# 2º Guardar endereço do AP e o andar/quarto 
	move $s0,$v0 # $s0 = endereço do AP
	lb $s1, 386($s0) # $s1 = andar, que é apagado junto ao bloco
	lb $s2, 387($s0) # $s2 = quarto, que é apagado junto com o bloco
	
	# 3º Zerar os 537 bytes do AP (incluindo moradores, status, quantidades e automóveis)
	move $a0, $s0 # $a0 = início do bloco a limpar
	li $a1, 537 # $a1 = tamanho de um AP em bytes
	jal limpar_buffer # Zera todos os bytes 
	
	# 4º Restaura andar/quarto, o AP volta ao estado  vazio (status = 0)
	sb $s1, 386($s0) # Regrava o andar
	sb $s2, 387($s0) # Regrava o quarto
	
	# Volta para a main
	j main_loop
infoAp:
	# Informações sobre o um AP
	
	# Verificar se option1 for "all", mostrar todos os APs
	
	la $t0, cmd_option1 # $t0 = endereço do buffer da option1
	lb $t1, 0($t0) # 1º caractere digitado
	bne $t1, 97, infoAp_um # Não é "a" (97), trata como número de AP
	lb $t1, 1($t0) # 2º caractere digitado	
	bne $t1, 108, infoAp_um # Não é "l" (108), trata como número de AP
	lb $t1, 2($t0) # 3º caractere digitado
	bne $t1, 108, infoAp_um # Não é "l" (108), trata como número de AP
	lb $t1, 3($t0) # 4º caractere digitado (encerra a palavra)
	beq $t1, $zero, infoAp_all # "\0', exatamente all
	beq $t1, 32, infoAp_all # Espaço: "all" (o parser deixa o espaço se houver outra opção)
	beq $t1, 10, infoAp_all # Quebra de linha também encerra a palavra
	
infoAp_um:
	# Verificar se o número do AP existe (se vazia, existeApt resolve)
	
	jal existeApt
	bltz $v0, main_loop
	# 3º Imprimir o AP  ($v0 = endereço, $v1 = número do AP)
	move $a0, $v0	# 1º argumento de imprimir (endereço)
	move $a1, $v1	# 2º argumento de imprimir (número do AP)
	jal imprimir_ap # Imprime vazio OU moradores + veículos
	
	# Volta para a main
	j main_loop # Fim do comando
infoAp_all:
	# Percorre os 24 APs em ordem crescente (101,102,201...1202)
	li $s2, 0 # $s2 = índice do AP (0 a 23)
infoAp_all_loop:
	beq $s2,24,main_loop # Passou pelos 24 Aps, volta para o terminal
	# Número do AP = (índice/2+1)*100 +(indice%2+1)
	
	srl $t0, $s2, 1	 # índice / 2
	addi $t0, $t0, 1 # $t0 = andar (1 a 12)
	li $t1, 100 # Multiplicador para formar o número
	multu $t0, $t1 # andar * 100
	mflo $t0 # $t0 = andar * 100
	andi $t2, $s2, 1 # índice % 2
	addi $t2, $t2, 1 # $t2 = quarto (1 ou 2)
	add $a1, $t0, $t2 # $a1 = número do AP (ex: 1102)
	
	# Endereço do AP = main_memory + indice * 537
	
	multu $s2, $t3 # índice * 537
	mflo $t3 # $t3 = deslocamento dentro da main_memory
	la $t4, main_memory # $t4 = início da tabela de APs
	add $a0, $t3, $t4 # $a0 = endereço do AP atual
	
	jal imprimir_ap	 # Imprime o AP atual ($a0 = endereço, $a1 = número)
	
	# Linha em branco separando um AP do outro
	
	li $v0, 4 # Syscall para imprimir string
	la $a0, quebra_linha # String "\n"
	syscall	# Imprime a linha em branco
	
	addi $s2, $s2, 1 # Próximo AP
	j infoAp_all_loop # Repete o laço
	
	
	

infoGeral:
	# Informações gerais dos APs
	# 1º Contar quantos dos 24 APs estão não vazios (Byte 384)
	la $t0, main_memory # $t0 = endereço do AP atual (começa pelo primeiro)
	
	li $t1,0 # $t1 = índice do AP
	li, $t2,0 # $t2 = contador de APs não vazios
infoGeral_loop:
	beq $t1, 24, infoGeral_calc # Calcula a porcentagem dos 24 apartamentos
	lb $t3 384($t0) # $t3 = status do AP (0 vazio, 1 não vazio)
	beq $t3, $zero, infoGeral_prox # Se for vazio, não conta
	addi $t2,$t2,1 # Soma andares não vazios
infoGeral_prox:
	addi $t0, $t0, 537 # Avança para o próximo AP 
	addi $t1, $t1, 1 # Próximo  indice
	j infoGeral_loop
infoGeral_calc:
	# 2º Calcular os números
	
	li $t4,24 # $t4 = total de APs
	sub $t5, $t4, $t2  # $t5 = AP vazios (24 - não vazios)
	li $t6,100 # Fator transforma em porcentagem
	multu $t2, $t6  # Não vazios * 100
	mflo $t7 # $t7 = $t2
	addi $t7, $t7, 12 # +12 para arredondar o calculo
	div $t7, $t4 # Divide por 24 (quociente em LO)
	mflo $t7 # $t7 = % de não vazios
	sub $t8, $t6, $t7 # $t8 = % de vazios
	
	# 3º Imprime Não Vazios e Porcentagem 
	
	li $v0, 4 # Syscall de print string
	la $a0, msg_nao_vazios 
	syscall
	li $v0,1 # Syscall de print inteiro
	move $a0, $t2 # Quantidade de APs não vazios
	syscall 
	li $v0,4 # Mesma coisa do primeiro syscall
	la $a0, msg_abre_par # Abre parenteses
	syscall 
	li $v0,1 # Mesma coisa do segundo syscall
	move $a0, $t7 # % de não vazios
	syscall 
	li $v0,4 # Mesma coisa do primeiro syscall
	la,$a0, msg_fecha_par # %, fecha parenteses e quebra linha
	syscall 
	
	# 4º Imprime Vazios
	
	li $v0,4 # Syscall de print string
	la $a0, msg_vazios 
	syscall
	li $v0,1 # Syscall de print inteiro
	move $a0, $t5 # Quantidade de APs vazios
	syscall
	li $v0, 4 # Mesma coisa do primeiro syscall
	la $a0, msg_abre_par # Abre parenteses
	syscall
	li $v0,1 # Mesma coisa do segundo syscall
	move $a0, $t8 # % de vazios 
	syscall 
	li $v0,4 # Mesma coisa do primeiro syscall
	la $a0, msg_fecha_par # %, fecha parenteses e quebra linha
	syscall
	
	# Volta para a main
	j main_loop

salvar:
	# Salva dados da memória no arquivo
	# 1º Preparar os registradores e chamar a função save_data
	la $a0, nome_arquivo		# Filename do arquivo
	la $a1, main_memory		# Buffer da memória principal
	lw $a2, max_main_memory		# Número de bytes da memória principal
	
	jal save_data		# Função para salvar os dados			
	
	# 2º Mensagem dizendo que os dados foram salvos
	li $v0, 4		# Syscall para imprimir na tela
	la $a0, msg_save	# Mensagem dizendo que as alterações foram salvas
	syscall
	
	# Volta para a main
	j main_loop

recarregar:
	# Carregar dados do arquivo na memória
	# 1º Abrir o arquivo "dados.txt" para leitura
	li $v0, 13		# Syscall para abrir o arquivo
	la $a0, nome_arquivo	# Caminho do arquivo ".txt"
	li $a1, 0		# Flag para ler o arquivo
	li $a2, 0		# Modo
	syscall
	
	move $t1, $v0		# Salva o file descriptor
	
	# 2º Ler dados do arquivo e carregar em main_memory
	li $v0, 14		# Syscall para ler arquivo
	move $a0, $t1		# Passa o file descriptor
	la $a1, main_memory	# Endereço de memória para onde os dados vão ser carregados
	lw $a2, max_main_memory # Tamanho máximo de bytes a serem lidos
	syscall
	
	# 3º Fechar o arquivo
	li $v0, 16		# Syscall para fechar o arquivo
	move $a0, $t1		# Define o file descriptor
	syscall
	
	# Volta para a main
	j main_loop

formatar:
	# Apaga todos os dados da memória, mas não do arquivo
	# 1º Mensagem de confirmação
	# Imprime mensagem de confirmação de formatação
	li $v0, 4
	la $a0, save_conf_msg
	syscall

form_conf_loop:
	# Lê o caractere do usuário 'S' ou 's' (Sim) ou "N" ou 'n' (Não)
	li $v0, 12
	syscall
	
	# Se o caractere lido for igual a 'S' ou 's', formata dados do programa
	beq $v0, 83, formated
	beq $v0, 115, formated
	
	# Se o caractere lido for igual a 'N' ou 'n', volta para o programa principal
	beq $v0, 78, main_loop
	beq $v0, 110, main_loop
	
	# Se o caractere lido for inválido, exibe uma mensagem de erro e volta a perguntar pelo caractere
	li $v0, 4
	la $a0, err_conf_msg
	syscall
	
	j formatar 		# Volta pedindo confirmação novamente

formated:
	# 2º Preparar argumentos e executar a função	
	la $a0, main_memory		# Endereço do buffer a ser limpo
	lw $a1, max_main_memory		# Número de bytes a serem limpos
	
	jal limpar_buffer		# Chama a função para limpar toda a memória principal do programa
	
	# Volta para a main
	j main_loop

help:
	# Exibe texto com os comandos, argumentos e a explicação de cada funcionalidade
	# 1º Escreve texto de comandos na tela
	li $v0, 4		# Syscall para imprimir string
	la $a0, help_rsp	# Endereço da mensagem que vai ser impressa
	syscall
	
	# Volta para a main
	j main_loop

exit:
	# Permite sair do programa e salvar os dados
	# 1º Mensagem de confirmação
	# Imprime mensagem de confirmação de salvamento
	li $v0, 4
	la $a0, save_conf_msg
	syscall
	
exit_conf_loop:
	# Lê o caractere do usuário 'S' ou 's' (Sim) ou "N" ou 'n' (Não)
	li $v0, 12
	syscall
	
	# Se o caractere lido for igual a 'S' ou 's', sai do programa salvando os dados
	beq $v0, 83, exit_save_confirmed
	beq $v0, 115, exit_save_confirmed
	
	# Se o caractere lido for igual a 'N' ou 'n', sai do programa sem salvar os dados
	beq $v0, 78, exit_no_save_confirmed
	beq $v0, 110, exit_no_save_confirmed
	
	# Se o caractere lido for inválido, exibe uma mensagem de erro e volta a perguntar pelo caractere
	li $v0, 4
	la $a0, err_conf_msg
	syscall
	
	j exit 		# Volta pedindo confirmação novamente
	
exit_save_confirmed:
	# Salvar dados antes de sair
	la $a0, nome_arquivo		# Filename do arquivo
	la $a1, main_memory		# Buffer da memória principal
	lw $a2, max_main_memory		# Número de bytes da memória principal
	
	jal save_data		# Executa a função
	
	# Mensagem dizendo que os dados foram salvos
	li $v0, 4		# Syscall para imprimir na tela
	la $a0, msg_save	# Mensagem dizendo que as alterações foram salvas
	syscall
	
	# Sair do simulador
	li $v0, 10		# Syscall para encerrar o simulador
	syscall

exit_no_save_confirmed:
	# Sair do simulador sem salvar os dados
	li $v0, 10		# Syscall para encerrar o simulador
	syscall


# -------------------------------------------------------
# Funções auxiliares
# -------------------------------------------------------

# Função: strcpy (destination, source)
# Função usada para copiar a string de source dentro de destination
# $a1 -> Endereço do source
# $a0 -> Endereço do destination

strcpy:	
	# Copia endereços para registradores temporários
	add $t0, $0, $a1 # Source
	add $t1, $0, $a0 # Destination
	
	# Carrega o caractere
	lb $t2, 0($t0) # Primeiro caractere
	
	
	loop_strcpy:
		# Testa se chegou no último caractere '\0'
		beq $t2, $0, exit_strcpy
	
		# Salva o caractere no buffer do destination
		sb $t2, 0($t1)
	
		# Incrementa
		addi $t0, $t0, 1
		addi $t1, $t1, 1
		
		# Próximo caractere
		lb $t2, 0($t0)
	
		# Volta o loop
		j loop_strcpy
	
	exit_strcpy:
		sb $t2, 0($t1) # Salva o '\0' caractere no buffer do destination
		
		add $v0, $0, $a0
		
		# Endereço de retorno
		# Volta para o main
		jr $ra

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
	
#funcao: existeApt
#verifica se o numero que o usuario digitou no cmd_option1 existe, ou seja, se esse apt realmente existe

existeApt:
	la $t5, cmd_option1
	lb $t1, 0($t5)#le o primeiro byte
	beq $t1, 0, invalido #verifica se eh 0, se for, eh invalido

addi $t0, $0, 0 #acumulador usado para somar/guardar o caracter em ascii
addi $t3, $0, 10 #valor usado para multiplicar o acumulador
#$t5 usado para guardar o valor original do endereco
# os numeros 0 a 9 em ascii valem de 48 a 57
# acumulador ira verificar se o que o usuario digitou esta dentro desse intervalo
acumulador:
	lb $t1, 0($t5) #le o caracter
	beq $t1, 0, separaAndar #chegou no fim da string
	beq $t1, 32, separaAndar #verifica se eh um espaco
	beq $t1, 10, separaAndar #nova linha (\n)
	
	blt $t1, 48, invalido  #verifica se eh menor que 48(0), se for, eh invalido
	bgt $t1, 57, invalido  #verifica se eh maior que 57(9), se for, eh invalido

#se for valido, calcula
	addi $t1, $t1, -48 #subtrai por 48
	multu $t0, $t3 # multiplica o acumulador por 10
	mflo $t0 #acessa o resultado da multiplicacao
	add $t0, $t1, $t0 #salva no acumulador o resultado
	addi $t5, $t5, 1 #passa para o proximo caracter
	j acumulador #volta para o loop

separaAndar:
#para descobrir o andar e o numero de quarto, divide o numero do apt por 100
#o quociente seria o andar e o resto o final do apt
#como so pode ter 2 apt por andar, o final seria 1 ou 2
addi $t1, $0, 100 #usado para fazer a divisao
	divu $t0, $t1 #faz a divisao
	mflo $t2 #acessa o quociente/andar
	blt $t2, 1, invalido #verifica se eh menor que 1
	bgt $t2, 12, invalido #verifica se eh maior que 12
	mfhi $t3 #acessa resto/quarto
	blt $t3, 1, invalido #verifica se eh menor que 1
	bgt $t3, 2, invalido #verifica se eh maior que 2
#se passou em tudo, entao calcula o endereco com o main
#faremos um indice:(andar-1).2 + (quarto-1)
#transformamos o andar e o quarto em indices de 0 a 23, apt 101 eh 0, 102 eh 1 e assim vai
#indice=$v0
	addi $t4, $t2, -1 #andar-1
	sll $t4, $t4, 1 #(andar-1).2
	addi $t5, $t3, -1 #quarto-1
	add $t4, $t4, $t5 #(andar-1).2 + (quarto-1)
addi $t5, $0, 537 #tamanho de cada apt
	multu $t4, $t5 #multiplica o indice pelo tamanho de um apt
	mflo $t6 #acessa o valor
	la $t7, main_memory #acessa o endereco da memoria principal
	add $v0, $t6, $t7 #soma o indice com o endereco de memoria, assim obtendo o endereco de um apt
	sb $t2, 386($v0) # Salva o andar (1 a 12) no byte 386
    	sb $t3, 387($v0) # Salva o quarto (1 ou 2) no byte 387
    	move $v1, $t0 # Deixa o numero completo (ex: 1102) em $v1
    	jr $ra
    	
invalido:
	li $v0, 4 # Syscall para escrever string
	la $a0, apt_invalido #imprime a mensagem de falha
	syscall	
	addi $v0, $0, -1 #manda para o retorno a falha
	jr $ra
	
	# Função: imprimir_ap (endereço, número)
# Imprime as informações de um AP no padrão do cmd_6 (infoAp)
# $a1 -> Número do AP (ex: 1102)
# $a0 -> Endereço do AP dentro da main_memory
# Layout assumido para os automóveis (addAuto/rmvAuto devem seguir o mesmo):
# byte 388: tipo ("c" = 99 ou "m" = 109)
# byte 389: quantidade de automóveis
# A partir do byte 390: slots de 73 bytes, um por automóvel
# slot + 0  : modelo (string terminada em "\0", até 56 bytes)
# slot + 56 : placa  (string terminada em "\0", até 17 bytes)

imprimir_ap:
	move $t0, $a0 # $t0 = endereço do AP
	move $t1, $a1 # $t1 = número do AP
	
	# Imprime Ap e Número
	
	li $v0, 4 # Syscall para printar string
	la $a0, msg_ap # "AP: "
	syscall 
	li $v0, 1 # Syscall para printar inteiro
	move $a0, $t1 # Número do AP
	syscall 
	li $v0, 4 # # Mesma coisa do primeiro syscall
	la $a0, quebra_linha 
	syscall	 
	
	# Se o status for 0, o AP está vazio
	lb $t4, 384($t0) # $t4 = status do AP
	bne $t4, $zero, imprimir_ap_cheio # Status != 0, tem moradores, segue para listar
	li $v0, 4 # Syscall para printar string
	la $a0, msg_ap_vazio		
	syscall
	jr $ra # Volta pra quem chamou

imprimir_ap_cheio:
	# Printa um morador por linha (percorre os 6 slots de 64 bytes)
	
	li $v0, 4 # Syscall para printar string
	la $a0, msg_moradores		
	syscall	
	li $t2, 0 # $t2 = slot atual (0 a 5)
	move $t3, $t0 # $t3 = ponteiro do slot (começa no byte 0 do AP)
	
imprimir_moradores_loop:
	beq $t2, 6, imprimir_autos # Percorreu os 6 slots, vai para os veículos
	lb $t4, 0($t3) # Primeiro byte do slot
	beq $t4, $zero, imprimir_morador_prox # 0 = slot livre, pula
	li $v0, 4 # Syscall para printar string
	move $a0, $t3 # Endereço do nome no slot
	syscall
	li $v0, 4 # Mesma coisa que o primeiro syscall
	la $a0, quebra_linha 
	syscall	
	
imprimir_morador_prox:
	addi $t3, $t3, 64 # Avança 64 bytes até o próximo slot
	addi $t2, $t2, 1 # Conta mais um slot
	j imprimir_moradores_loop # Volta pro laço

imprimir_autos:
	lb $t5, 389($t0) # $t5 = quantidade de automóveis
	beq $t5, $zero, imprimir_ap_fim	 # Sem automóveis: nada a mostrar
	
	# Carro ou Moto, conforme o tipo
	lb $t6, 388($t0) # $t6 = tipo do automóvel
	beq $t6, 99, imprimir_rotulo_carro # 99 = "c", é carro
	li $v0, 4 # Syscall para printar string
	la $a0, msg_moto 
	syscall	 
	j imprimir_autos_lista # Pula o rótulo do carro
	
imprimir_rotulo_carro:
	li $v0, 4 # Syscall para printar string
	la $a0, msg_carro 
	syscall	
	
imprimir_autos_lista:
	addi $t3, $t0, 390 # $t3 = primeiro slot de automóvel (byte 390 do AP)
	li $t2, 0# $t2 = automóvel atual
	
imprimir_autos_loop:
	beq $t2, $t5, imprimir_ap_fim # Imprimiu todos os automóveis, termina
	
	# Modelo e Placa
	
	li $v0, 4 # Syscall para printar string
	la $a0, msg_tab	
	syscall	
	li $v0, 4 # Mesma coisa que o primeiro syscall
	move $a0, $t3 # Modelo está no início do slot (+0)
	syscall					
	li $v0, 4 # Mesma coisa que o primeiro syscall
	la $a0, msg_barra		
	syscall					
	li $v0, 4 # Mesma coisa que o primeiro syscall
	addi $a0, $t3, 56 # Placa está em slot + 56
	syscall
	li $v0, 4 # Syscall para printar string
	la $a0, quebra_linha			
	syscall	 
	
	addi $t3, $t3, 73 # Avança 73 bytes até o próximo slot de automóvel
	addi $t2, $t2, 1 # Conta mais um automóvel
	j imprimir_autos_loop # Volta para o laço

imprimir_ap_fim:
	jr $ra # Volta para quem chamou




# Função: save_data (file, buffer, num)
# Função usada para salvar dados de um buffer me um arquivo
# $a2 -> Número de bytes a serem salvos
# $a1 -> Endereço do buffer
# $a0 -> Endereço do nome do arquivo '.txt' (path)

save_data:
	# Salvar registradores na pilha
	addi $sp, $sp, -8
	sw $a1, 0($sp)
	sw $a2, 4($sp)
	
	# Abre o arquivo ($a0 = nome do arquivo)
	li $v0, 13		# Syscall para abrir um arquivo
	li $a1, 1		# Flag para escrever no arquivo
	li $a2, 0		# Modo
	syscall
	
	# Salva file descriptor
	move $t1, $v0
	
	# Recupera registradores
	lw $a2, 4($sp)
	lw $a1, 0($sp)
	
	# Escreve dados no arquivo ($a1 = buffer, $a2 = numero de bytes)
	li $v0, 15		# Syscall para escrever em um arquivo
	move $a0, $t1		# Define o file descriptor
	syscall
	
	# Fecha o arquivo
	li $v0, 16		# Syscall para fechar o arquivo
	move $a0, $t1		# Define o file descriptor
	syscall


