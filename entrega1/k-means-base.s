#
# IAC 2023/2024 k-means
# 
# Grupo: 34
# Campus: Alameda
#
# Autores:
# 109293, Diogo Lobo
# 109803, Hugo Pereira
# 109939, Vicente Duarte
#
# Tecnico/ULisboa


##########################################################
#      _  __     __  __ ______          _   _  _____     #
#     | |/ /    |  \/  |  ____|   /\   | \ | |/ ____|    #
#     | ' /_____| \  / | |__     /  \  |  \| | |___      #
#     |  <______| |\/| |  __|   / /\ \ | . ` |\___ \     #
#     | . \     | |  | | |____ / ____ \| |\  |____| |    #
#     |_|\_\    |_|  |_|______/_/    \_\_| \_|_____/     #
#                                                        #
########################################################## 
                                                
                                                

# ALGUMA INFORMACAO ADICIONAL PARA CADA GRUPO:
# - A "LED matrix" deve ter um tamanho de 32 x 32
# - O input e' definido na seccao .data. 
# - Os vetores points e centroids estao na forma x0, y0, x1, y1, ...


# Variaveis em memoria
.data

#Input A - linha inclinada
#n_points:    .word 9
#points:      .word 0,0, 1,1, 2,2, 3,3, 4,4, 5,5, 6,6, 7,7 8,8

#Input B - Cruz
#n_points:    .word 5
#points:     .word 4,2, 5,1, 5,2, 5,3 6,2

#Input C
#n_points:    .word 23
#points: .word 0,0, 0,1, 0,2, 1,0, 1,1, 1,2, 1,3, 2,0, 2,1, 5,3, 6,2, 6,3, 6,4, 7,2, 7,3, 6,8, 6,9, 7,8, 8,7, 8,8, 8,9, 9,7, 9,8

#Input D
n_points:    .word 30
points:      .word 16, 1, 17, 2, 18, 6, 20, 3, 21, 1, 17, 4, 21, 7, 16, 4, 21, 6, 19, 6, 4, 24, 6, 24, 8, 23, 6, 26, 6, 26, 6, 23, 8, 25, 7, 26, 7, 20, 4, 21, 4, 10, 2, 10, 3, 11, 2, 12, 4, 13, 4, 9, 4, 9, 3, 8, 0, 10, 4, 10

#Input hsort
#n_points:    .word 72
#points:      .word 4, 16, 4, 17, 4, 18, 4, 19, 4, 20, 5, 18, 6, 19, 7, 18, 7, 17, 7, 16, 9, 17, 10, 16, 11, 16, 12, 17, 11, 18, 10, 19, 9, 20, 10, 21, 11, 21, 12, 20, 14, 17, 14, 18, 15, 19, 16, 19, 17, 18, 17, 17, 16, 16, 15, 16, 19, 16, 19, 17, 19, 18, 19, 19, 20, 18, 21, 19, 24, 16, 24, 17, 24, 18, 24, 19, 24, 20, 24, 21, 23, 20, 25, 20, 6, 7, 6, 8, 6, 9, 6, 10, 7, 11, 8, 12, 9, 13, 10, 13, 11, 13, 12, 12, 13, 11, 14, 10, 14, 9, 14, 8, 14, 7, 13, 6, 12, 5, 11, 4, 10, 4 , 9, 4, 8, 5, 7, 6, 18, 8, 17, 8, 20, 8, 21, 9, 21, 8, 21, 7, 21, 6, 21, 5


# Valores de centroids e k a usar na 1a parte do projeto:
centroids:   .word 0,0
k:           .word 1

# Valores de centroids, k e L a usar na 2a parte do prejeto:
#centroids:   .word 0,0, 10,0, 0,10
#k:           .word 3
#L:           .word 10

# Abaixo devem ser declarados o vetor clusters (2a parte) e outras estruturas de dados
# que o grupo considere necessarias para a solucao:
#clusters:    




#Definicoes de cores a usar no projeto 


# K0 - Vermelho, K1 - Verde, K2 - Azul 
colors:      .word 0xff0000, 0x00ff00, 0x0000ff  # Cores dos pontos do cluster 0, 1, 2, etc.

.equ         black      0
.equ         white      0xffffff



# Codigo
 
.text
    # Chama funcao principal
    jal ra, mainSingleCluster
    
    #Termina o programa (chamando chamada sistema)
    li a7, 10
    ecall


### printPoint
# Pinta o ponto (x,y) na LED matrix com a cor passada por argumento
# Nota: a implementacao desta funcao ja' e' fornecida pelos docentes
# E' uma funcao auxiliar que deve ser chamada pelas funcoes seguintes que pintam a LED matrix.
# Argumentos:
# a0: x
# a1: y
# a2: cor

printPoint:
    li a3, LED_MATRIX_0_HEIGHT
    sub a1, a3, a1
    addi a1, a1, -1
    li a3, LED_MATRIX_0_WIDTH
    mul a3, a3, a1
    add a3, a3, a0
    slli a3, a3, 2
    li a0, LED_MATRIX_0_BASE
    add a3, a3, a0   # addr
    sw a2, 0(a3)
    jr ra
    

### cleanScreen
# Limpa todos os pontos da matrix
# Argumentos: nenhum
# Retorno: nenhum

cleanScreen:
    # Guarda em registos temporarios o tamanho maximo da matrix
    li t0, LED_MATRIX_0_WIDTH

    # Carrega o offset inicial da matrix na memoria
    # e cria um limite maximo para o valor do offset
    li t1, LED_MATRIX_0_BASE
    mul t0, t0, t0
    slli t0, t0, 2
    add t0, t1, t0
    
    # Define a cor do cluster como branca
    li t2, white #cor

    clearScreenLoop:
        # Muda o valor da cor na matrix (em dois pontos consecutivos)
        sw t2, 0(t1)
        sw t2, 4(t1)
    
        # Itera para o proximo ponto e verifica se nao ultrapassou o limite maximo
        addi t1, t1, 8
        blt t1, t0 clearScreenLoop
    
        jr ra

    
### printClusters
# Pinta os agrupamentos na LED matrix com a cor correspondente.
# Argumentos: nenhum
# Retorno: nenhum

printClusters:
    # Aloca memoria e guarda no stack point 
    # o return address para chamada futura
    addi sp, sp, -4
    sw ra, 0(sp)

    # Carrega o numero de pontos do input 
    lw t1, n_points

    # Carrega o endereco de memoria onde os pontos estao guardados
    # e cria um limite maximo para esse endereco de memoria
    la t3, points
    slli t1, t1, 3
    add t1, t3, t1

    # Guarda o endereco da memoria das cores num registo temporario
    la a2, colors
    
    # Carregar valor de K e multiplica-o por 4 
    # para carregar a cor correspondente
    lw t0, 8(sp)
    slli t0, t0, 2
    add a2, a2, t0
    lw a2, 0(a2)
    
    printClustersLoop:
        # Carrega a coordenada x e y do ponto e pinta na matrix esse ponto
        lw a0, 0(t3)
        lw a1, 4(t3)
        jal ra, printPoint

        # Avanca para o proximo ponto do input
        addi t3, t3, 8
        
        # Verifica se nao ultrapassou o limite maximo
        blt t3, t1, printClustersLoop

        # Carrega o return address e liberta a memoria previamente alocada no stack point
        lw ra, 0(sp)
        addi sp, sp, 4
    
        jr ra


### printCentroids
# Pinta os centroides na LED matrix
# Argumentos: nenhum
# Retorno: nenhum

printCentroids:
    # Aloca memoria e guarda no stack point o return address para chamada futura
    addi sp, sp, -4
    sw ra 0(sp)

    # Carrega a coordenada do centroid guardado pela funcao calculateCentroids
    la t1, centroids
    lw a0, 0(t1) # x
    lw a1, 4(t1) # y

    # Define a cor do centroid como preta
    li a2, black # cor

    # Pinta o centroid na matrix
    jal ra, printPoint

    # Carrega o return address e liberta a memoria previamente alocada no stack point
    lw ra 0(sp)
    addi sp, sp, 4
    
    jr ra

  
### calculateCentroids
# Calcula os k centroides, a partir da distribuicao atual de pontos associados a cada agrupamento (cluster)
# Argumentos: nenhum
# Retorno: nenhum

calculateCentroids:
    # Carrega o endereco de memoria onde os pontos estao guardados 
    # e o numero de pontos do input 
    la t1, points
    lw t2, n_points
    
    # Cria um limite maximo para esse endereco de memoria
    slli t3, t2, 3
    add t3, t1, t3

    
    calculateCentroidsLoop:
        # Carrega o valor da coordenada x do ponto e adiciona-o ao registo temporario que guarda o 
        # somatorio de todos os x's
        lw t4, 0(t1)
        add t5, t5, t4

        # Carrega o valor da coordenada y do ponto e adiciona-o ao registo temporario que guarda o 
        # somatorio de todos os y's
        lw t4, 4(t1)
        add t6, t6, t4

        # Avanca para o proximo ponto do input e incrementa o iterador
        addi t1, t1, 8

        # Verifica se nao ultrapassou o limite maximo
        blt t1, t3, calculateCentroidsLoop

        # Divide o somatario dos x's pelo numero de pontos (media)
        div t5, t5, t2

        # Divide o somatario dos y's pelo numero de pontos (media)
        div t6, t6, t2

        # Guarda em memoria as medias dos x's e dos y's como um ponto individual
        la t1, centroids
        sw t5, 0(t1)
        sw t6, 4(t1)
    
        jr ra


### mainSingleCluster
# Funcao principal da 1a parte do projeto.
# Argumentos: nenhum
# Retorno: nenhum

mainSingleCluster:
    # Aloca memoria e guarda no stack point o return address para chamada futura
    addi sp, sp, -8
    sw ra, 0(sp)
    
    #1. Coloca k=1 e guarda-o no stack point
    lw t0, k
    sw t0, 4(sp)

    # Limpa a matrix chamando a funcao cleanScreen
    jal ra, cleanScreen

    # Pinta todos os pontos do input na matrix chamando a funcao printClusters
    jal ra, printClusters

    # Calcula a media dos pontos do input chamando a funcao calculateCentroids
    jal ra, calculateCentroids
    
    # Pinta o centroid chamando a funcao printCentroids
    jal ra, printCentroids

    # Carrega o return address e liberta a memoria previamente alocada no stack point
    lw ra, 0(sp)
    addi sp, sp, 8
    
    jr ra
