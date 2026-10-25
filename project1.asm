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
	banner:			.asciiz "SAHJ-shell>> "
	quebra_linha:		.asciiz "\n"
	erro_msg:		.asciiz "Comando invalido!\n"
	nome_arquivo:		.asciiz "dados.txt"
	msg_save:		.asciiz "Alterações salvas com sucesso!\n"
	titulo:			.asciiz "------------------------------\n      SISTEMA CONDOMÍNIO      \n------------------------------\n\n"
	help_rsp:		.asciiz "\n------------------------------------------------------------------------------------------------------------------------\n                                                   COMANDOS DO SISTEMA                                                  \n------------------------------------------------------------------------------------------------------------------------\n\n\t- addMorador --<option1> --<option2>\n\t\t// <option1>: Numero do apartamento (ex: 101 a 1202)\n\t\t// <option2>: Nome completo do morador a ser adicionado (max: 6 por AP)\n\n\t- rmvMorador --<option1> --<option2>\n\t\t// <option1>: Numero do apartamento\n\t\t// <option2>: Nome do morador a ser removido\n\n\t- addAuto --<option1> --<option2> --<option3> --<option4>\n\t\t// <option1>: Numero do apartamento\n\t\t// <option2>: Tpo do veiculo ('c' para Carro [max 1] ou 'm' para Moto [max 2])\n\t\t// <option3>: Modelo do veiculo (ex: Fiat Uno)\n\t\t// <option4>: Placa do veiculo (ex: ABC1234)\n\n\t- rmvAuto --<option1> --<option2>\n\t\t// <option1>: Numero do apartamento\n\t\t// <option2>: Placa do veiculo a ser removido\n\n\t- limparAp --<option1>\n\t\t// <option1>: Numero do apartamento cujos dados serao apagados da memoria\n\n\t- infoAp --<option1>\n\t\t// <option1>: Numero do apartamento para exibir detalhes (moradores e veiculos)\n\n\t- infoGeral\n\t\t// Exibe estatisticas gerais do condominio (porcentagem de APs ocupados/vazios)\n\n\t- salvar\n\t\t// Salva os dados atuais contidos na memoria RAM para o arquivo 'dados.txt'\n\n\t- recarregar\n\t\t// Carrega e atualiza a memoria RAM com os dados salvos em 'dados.txt'\n\n\t- formatar\n\t\t// Limpa todos os dados da memoria RAM (nao altera o arquivo no disco)\n\n\t- help\n\t\t// Exibe esta lista de comandos do sistema\n\n\t- exit\n\t\t// Permitir sair do programa principal e salvar os dados\n\n------------------------------------------------------------------------------------------------------------------------\n\n"
	save_conf_msg:		.asciiz "Deseja salvar as alteracoes? [S/N]: " 	# Mensagem de confirmação de salvamento
	err_conf_msg:		.asciiz "Caractere invalido! Por favor digite apenas 'S' ou 'N'!\n"
	form_conf_msg:		.asciiz "Deseja apagar todos os dados do programa atual? [S/N]: "
	msg_limite_auto:        .asciiz "Falha: AP com numero max de automóveis\n"
	msg_tipo_invalido:      .asciiz "Falha: tipo invalido\n"
	msg_auto_nao_encontrado:    .asciiz "Falha: automóvel nao encontrado"
	
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
	
	# Verificar se o arquivo .txt já existe ou precisa ser criado 
	li $v0, 13             # abrir arquivo
	la $a0, nome_arquivo   # entrega o nome dele
 	li $a1, 0              # modo (leitura)
 	syscall
 	
 	blt $v0, $0, criar_arquivo   # se $v0 for menor que zero, precisa ser criado.		
 	
 	move $a0, $v0       # entrega file descriptor para $a0
 	li $v0, 16          # fecha arquivo   
 	syscall
 	
        # Recarregar os últimos dados do arquivo para o programa
 	j recarregar     
 	         	       
        criar_arquivo:   
	li $v0, 13             # criar arquivo (modo escrita, $a1 = 1)
	la $a0, nome_arquivo   # entrega o nome dele
 	li $a1, 1              
 	syscall
 	
 	move $a0, $v0   # entrega o file descriptor para $a0
 	li $v0, 16      # fecha arquivo
 	syscall
	j main_loop


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
	# 1º Verificar se os buffers option1 e option2 não estão vazios
	# 2º Verificar se o número do AP existe
	# 3º Verificar se o nome da pessoa já existe no AP
	# 4º Verificar se o número máximo de pessoas foi atingido (máx 6)
	# 5º Calcular o endereço de memória no AP
	# 6º Salvar o nome da pessoa no respectivo endereço
	# 7º Caso o status do quarto seja vazio, mudar para não vazio
	
	# Volta para a main
	j main_loop

rmvMorador:
	# Remove um morador de um AP
	# 1º Verificar se os buffers option1 e option2 não estão vazios
	# 2º Verificar se o número do AP existe
	# 3º Verificar se o nome da pessoa existe no AP
	# 4º Verificar se o número pessoas é maior que zero
	# 5º Calcular o endereço de memória no AP
	# 6º Remover o nome da pessoa no respectivo endereço
	# 7º Caso o status do AP seja não vazio e só tenha 1 pessoa, mudar para vazio
	
	# Volta para a main
	j main_loop

addAuto:
	# Verifica se os buffers option1, option2, option3, option4 não estão vazios
	la $t0, cmd_option1
	lb $t1, 0($t0)
	beq $t1, $0, erro_msg_vazio
	
	la $t0, cmd_option2
	lb $t1, 0($t0)
	beq $t1, $0, erro_msg_vazio
	
	la $t0, cmd_option3
	lb $t1, 0($t0)
	beq $t1, $0, erro_msg_vazio
	
	la $t0, cmd_option4
	lb $t1, 0($t0)
	beq $t1, $0, erro_msg_vazio
			
	
	# Verifica se o número do AP existe
	jal existeApt                    # Chama a função 
	blt $v0, $zero, main_loop        # Se $v0 for menor que 0, o erro já foi impresso, volta pro menu.
	move $s0, $v0                    # Se não, salva o endereço do AP em $s0.
	
	
	# Verifica o tipo do automóvel e se ele existe no AP
	verifica_tipo:
	la $t0, cmd_option2   # carrega o endereço do tipo digitado
	lb $t1, 0($t0)        # carrega o tipo 
	lb $t2, 388($s0)      # carrega o tipo que ja existe no AP
		
	beq $t1, 99, verifica_se_tem_espaço     # checa se é um carro a ser adicionado, se for, checa se ja tem espaço no AP
	beq $t1, 109, verifica_se_tem_2_motos   # se não for carro, checa se é moto, se for, checa se tem 2 motos no AP
	
	tipo_invalido:      # se não for carro nem moto, printa mensagem de tipo inválido
	li $v0, 4	 
	la $a0, msg_tipo_invalido		 
	syscall
	j main_loop
		
	                                   	                                   	                                   	                                   	
	verifica_se_tem_espaço:                    
	bne $t2, 0, aviso_limite        # se não estiver vazio, ja nao da pra adicionar o carro, avisa que não dá.
	j adiciona_carro                # se estiver vazio, adiciona
	 	                                
	                                                              
	verifica_se_tem_2_motos: 
	lb $t3, 389($s0)              # carrega quantidade de veiculos
	beq $t2, 99, aviso_limite     # verifica se o tipo la dentro é um carro, se for, ja ta no limite
	bgeu $t3, 2, aviso_limite     # se houver 2 motos, avisa que não da para adicionar
	j adiciona_moto               # se houver menos que duas, adiciona
	
	 
	
        adiciona_carro: 
	li $t4, 99
	sb $t4, 388($s0)        # atualiza o tipo salvando 'c' no byte 388 do AP
	li $t4, 1
	sb $t4, 389($s0)        # atualiza a quantidade no byte 389 do AP
	
        addi $a0, $s0, 390      # Destino: endereço do AP + 390
	la $a1, cmd_option3     # Origem: modelo digitado
	jal strcpy
	
	addi $a0, $s0, 454      # Destino: endereço do AP + 454
	la $a1, cmd_option4     # Origem: placa digitada
	jal strcpy                         	
        
        j main_loop
                
        
        adiciona_moto:
	li $t4, 109
	sb $t4, 388($s0)        # atualiza o tipo salvando 'm' no byte 388 do AP
	lb $t3, 389($s0)        # Lê a quantidade atual de motos 
	addi $t3, $t3, 1        # Soma 1
	sb $t3, 389($s0)        # Salva a nova quantidade no byte 389
	
	lb $t4, 390($s0)            # Olha a primeira letra do modelo da Vaga 1
	bne $t4, $zero, moto_vaga2  # Se não for zero, a vaga 1 está ocupada, vai pra vaga 2
	
	                             
	addi $a0, $s0, 390          # Se chegou aqui, a vaga 1 está livre, copia modelo para o destino
	la $a1, cmd_option3         # Origem 
	jal strcpy
	
	addi $a0, $s0, 454         # Destino
	la $a1, cmd_option4        # Origem
	jal strcpy
	j main_loop

        moto_vaga2:
	addi $a0, $s0, 464      # Destino: endereço do AP + 464
	la $a1, cmd_option3     # Origem: modelo digitado
	jal strcpy
	
	addi $a0, $s0, 528      # Destino: endereço do AP + 528
	la $a1, cmd_option4     # Origem: placa digitada
	jal strcpy
        j main_loop
        
        
            
        aviso_limite:
        li $v0, 4		      # Syscall para escrever string
	la $a0, msg_limite_auto       # msg a ser exibida
	syscall
	j main_loop
	
	erro_msg_vazio:
	li $v0, 4	 
	la $a0, erro_msg		 
	syscall 
	j main_loop

rmvAuto:
	
	# Verifica se os buffers option1 e option2 não estão vazios
	la $t0, cmd_option1
	lb $t1, 0($t0)
	beq $t1, $0, erro_msg
	
	la $t0, cmd_option2
	lb $t1, 0($t0)
	beq $t1, $0, erro_msg
	
	# Verifica se o número do AP existe
	jal existeApt                   # Chama a função 
	blt $v0, $zero, main_loop       # Se $v0 for menor que 0, o erro já foi impresso, volta pro menu.
	move $s0, $v0                   # Salva o endereço do AP em $s0.
	
	# Verificar se existe um automovel no AP
	lb $t0, 389($s0)
	beq $t0, $zero, auto_nao_encontrado  # Se for 0, não tem o que remover
	
	
	addi $a0, $s0, 454                 # $a0 = endereço da placa da vaga 1
	la $a1, cmd_option2                # $a1 = placa digitada pelo usuário
	jal strcmp                         # Compara as duas strings
	beq $v0, $zero, remover_vaga1      # Se $v0 = 0, as placas são iguais, vai apagar a vaga 1
	
	addi $a0, $s0, 528                 # $a0 = endereço da placa da vaga 2
	la $a1, cmd_option2                # $a1 = placa digitada pelo usuário
	jal strcmp                         # Compara as duas strings
	beq $v0, $zero, remover_vaga2      # Se $v0 = 0, achou na vaga 2, vai apagar a vaga 2
	
	j auto_nao_encontrado
	
        
        
        remover_vaga1:
	addi $a0, $s0, 390                 # início da vaga 1 
	li $a1, 74                         # 74 bytes para zerar (64 do modelo + 10 da placa)
	jal limpar_buffer
	j atualizar_qtd_auto

        remover_vaga2:
	addi $a0, $s0, 464                 # início da vaga 2 
	li $a1, 74                         # 74 bytes para zerar
	jal limpar_buffer

        atualizar_qtd_auto:
	lb $t0, 389($s0)                   # lê a quantidade atual de veículos
	addi $t0, $t0, -1                  # diminui 1 veículo
	sb $t0, 389($s0)                   # salva a nova quantidade no byte 389
	
	# se ainda sobrou 1 moto, já pode voltar pro menu:
	bne $t0, $zero, main_loop
	
	# se a quantidade chegou a 0, reseta o tipo de veículo (byte 388) para 0 também
	sb $zero, 388($s0)
	j main_loop
        
        
        auto_nao_encontrado:
	li $v0, 4	 
	la $a0, msg_auto_nao_encontrado		 
	syscall 
	j main_loop
		

limparAp:
	# Apaga dados do AP na memória
	# 1º Verificar se o buffer option1 não está vazio
	# 2º Verificar se o número do AP existe
	# 3º Limpar todo o AP na memória e no arquivo
	
	# Volta para a main
	j main_loop

infoAp:
	# Informações sobre o um AP
	# 1º Verificar se o buffer option1 não está vazio
	# 2º Verificar se o número do AP existe
	# 3º Caso o AP não esteja vazio, listar informações
	# 4º Caso contrário, imprimir o número do AP e seu status de vazio
		
	# Volta para a main
	j main_loop

infoGeral:
	# Informações gerais dos APs
	# 1º Informaçõs da porcentagem de APs vazios e APs não vazios
		
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


