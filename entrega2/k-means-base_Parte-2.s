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
#centroids:   .word 0,0
#k:           .word 1

# Valores de centroids, k e L a usar na 2a parte do prejeto:
centroids:   .word 0,0 0,0 0,0
k:           .word 3
L:           .word 10

# Abaixo devem ser declarados o vetor clusters (2a parte) e outras estruturas de dados
# que o grupo considere necessarias para a solucao:
clusters: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,    
n_clusters: .word 0, 0, 0
centroids_sum: .word 0, 0, 0, 0, 0, 0



#Definicoes de cores a usar no projeto 


# K0 - Vermelho, K1 - Verde, K2 - Azul 
colors:      .word 0xff0000, 0x00ff00, 0x0000ff  # Cores dos pontos do cluster 0, 1, 2, etc.

.equ         black      0
.equ         white      0xffffff



# Codigo
 
.text
    # Chama funcao principal
    #jal ra, mainSingleCluster
    
    jal ra, mainKMeans
    
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
    lw t0, 4(sp)
    
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
    la t6, colors
    
    la t5, clusters
    
    addi t0, t0, -1
    lw a2, 0(t6)
    printClustersLoop:
        # Carrega a coordenada x e y do ponto e pinta na matrix esse ponto
        lw a0, 0(t3)
        lw a1, 4(t3)
        
        blt t0, x0, skip
        
        lw a2, 0(t5)
        
        slli a2, a2, 2
        add t4, t6, a2
        lw a2, 0(t4)
        
    skip:
        jal ra, printPoint

        # Avanca para o proximo ponto do input
        addi t3, t3, 8
        addi t5, t5, 4
        
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
    lw t0, 4(sp)
    
    # Aloca memoria e guarda no stack point o return address para chamada futura
    addi sp, sp, -4
    sw ra 0(sp)

    # Carrega a coordenada do centroid guardado pela funcao calculateCentroids
    la t1, centroids
    la t2, colors
    
    # Cria um limite maximo para esse endereco de memoria
    slli t0, t0, 3
    add t3, t1, t0
    
    printCentroidsLoop:
        lw a0, 0(t1) # x
        lw a1, 4(t1) # y

        # Define a cor do centroid como preta
        li a2, 0x0

        # Pinta o centroid na matrix
        jal ra, printPoint
        
        addi t1, t1, 8
        
        # Verifica se nao ultrapassou o limite maximo
        blt t1, t3, printCentroidsLoop

    # Carrega o return address e liberta a memoria previamente alocada no stack point
    lw ra, 0(sp)
    addi sp, sp, 4
    
    jr ra

  
### calculateCentroids
# Calcula os k centroides, a partir da distribuicao atual de pontos associados a cada agrupamento (cluster)
# Argumentos: nenhum
# Retorno: a0: houve mudanca nos centroids

calculateCentroids:
    
    # Carrega o K e verifica qual calculateCentroid executar
    lw t0, 4(sp)
    li t5, 1
    bgt t0, t5, calculateCluster
    
    
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
        
        li a0, 1
        
        j fimCalculateCentroids
    
    calculateCluster:
        
        # Aloca memoria e guarda todos os s modificados
        addi sp, sp, -32
        sw ra, 0(sp)
        sw s0, 4(sp)
        sw s1, 8(sp)
        sw s2, 12(sp)
        sw s3, 16(sp)
        sw s4, 20(sp)
        sw s5, 24(sp)
        sw s6, 28(sp)
        
        # Load ao endereco de memoria do clusters
        la s0, clusters
        
        # Load ao endereco de memoria dos pontos e ao numero de pontos
        # e define um valor maximo
        la s1, points
        lw t2, n_points
        slli t2, t2, 3
        add s2, s1, t2
        
        # Define alguns registos iniciais a 0 e carrega o endereco dos centroids,
        # centroids_sum e n_clusters
        li s3, 0
        li s4, 0
        la s5, centroids
        la s6, centroids_sum
        la s7, n_clusters
        
        calculateClusterLoop:
            # Carrega o valor da coordenada x do ponto
            lw s3, 0(s1)
            mv a0, s3
        
            # Carrega o valor da coordenada y do ponto
            lw s4, 4(s1)
            mv a1, s4
            
            # Chama a funcao nearestCluster para verificar
            # qual ? o cluster mais perto do ponto
            jal ra, nearestCLuster
            sw a0, 0(s0)
            
            # Vai para o endereco de momoria do centroids_sum correspondente ao k
            slli a0, a0, 3
            add s6, s6, a0
            
            # Soma o X do ponto correspondente ao cluster e guarda-o em memoria
            lw t0, 0(s6)
            add t0, t0, s3
            sw t0, 0(s6)
         
            # Soma o Y do ponto correspondente ao cluster e guarda-o em memoria
            lw t0, 4(s6)
            add t0, t0, s4
            sw t0, 4(s6)
            
            # Regenera o s6 original para as proxima iteracoes
            sub s6, s6, a0
            
            # Vai para o endereco de momoria do n_clusters correspondente ao k
            srli a0, a0, 1
            add s7, s7, a0
            
            # Soma 1 ao numero de pontos nesse cluster
            lw t0, 0(s7)
            addi t0, t0, 1
            sw t0, 0(s7)
            
            # Regenera o s7 original para as proxima iteracoes
            sub s7, s7, a0
            
            # Avanca para o proximo ponto do input e incrementa o iterador
            addi s1, s1, 8
            
            # Avanca para o proximo ponto do clusters
            addi s0, s0, 4
        
            # Verifica se nao ultrapassou o limite maximo
            blt s1, s2, calculateClusterLoop
            
    calculateNewCentroid:
        # Carrega do stackpoint o k original
        lw t0, 36(sp)
        
        # Carrega do endereco de memoria de centroids e define o seu valor maximo
        slli t0, t0, 3
        la t4, centroids
        add t5, t4, t0
        
        li a0, 0
        
        calculateNewCentroidLoop:
            # Carrega o somatorio de X, Y, e o numero de pontos de cada cluster
            lw t1, 0(s6)
            lw t2, 4(s6)
            lw t3, 0(s7)
            
            # Faz a media ponderada do X e do Y individualmente
            div t1, t1, t3
            div t2, t2, t3 
            
            # Verifica se existe 0/0, caso positivo, nao muda valores
            blt t1, x0, skiplesszero
            blt t2, x0, skiplesszero
            
            # Carrega os valores antigos do centroid e verifica se houve mudanca
            lw t0, 0(t4)
            sw t1, 0(t4)
            
            beq t0, t1, sameXcoord
            
            #Caso nao haja mudanca, adicionar ao registo de retorno como 1
            addi a0, a0, 1
            
            sameXcoord:
                
                # Fazer as mesmas verificacoes para o eixo dos Y
                lw t0, 0(t4)
                sw t2, 4(t4) 
                
                beq t0, t1, skiplesszero
                
                addi a0, a0, 1
            
        skiplesszero:
            # Avanca para o proximo ponto do centroids_sum e n_clusters e incrementa o iterador
            addi s6, s6, 8
            addi s7, s7, 4
            addi t4, t4, 8
            
            blt t4, t5, calculateNewCentroidLoop
    
    # Regenera os valores originais de s'
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    
    # Carrega o return address e liberta a memoria previamente alocada no stack point
    lw ra, 0(sp)
    addi sp, sp, 32

    fimCalculateCentroids:
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
    li t0, 1
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
    
    
### mainKMeans
# Funcao principal da 2a parte do projeto.
# Argumentos: nenhum
# Retorno: nenhum

mainKMeans:
    # Aloca memoria e guarda no stack point 
    # o return address para chamada futura
    addi sp, sp, -16
    sw ra, 0(sp)
    
    lw t0, k
    sw t0, 4(sp)
    
    sw s0, 8(sp)
    sw s1, 12(sp)
    li s0, 0
    lw s1, L
    
    jal ra, initializeCentroids
    
    jal ra, printCentroids
    
    mainKMeansLoop:
        
        addi s0, s0, 1
        
        jal ra, cleanScreen
    
        jal ra, calculateCentroids
        
        bgt a0, x0, CentroidsWasChanged 
        
        mv s0, s1
        
        CentroidsWasChanged:
            jal ra, printClusters
        
            jal ra, printCentroids
        
            blt s0, s1 mainKMeansLoop
        
    
    # Carrega o return address e liberta a memoria previamente alocada no stack point
    lw ra, 0(sp)
    lw s0, 8(sp)
    lw s1, 12(sp)
    addi sp, sp, 16
    
    jr ra
    
### initializeCentroids
# Inicializa os	valores	iniciais do vetor centroids com valores pseudo-aleatorio
# Argumentos: nenhum
# Retorno: nenhum
 
initializeCentroids:
    # Aloca memoria e guarda no stack point 
    # o return address para chamada futura
    addi sp, sp, -4
    sw ra 0(sp)
    
    # Guarda-se em t0 o tamanho maximo da matrix
    li t0, LED_MATRIX_0_WIDTH
    
    # Carrega o endereço do vetor centroids
    la t3, centroids
    
    # Carrega em t4 o immediate 3, multiplica-se por 12
    # e adiciona-se o endereço guardado em t3
    li t4, 3
    slli t4, t4, 3
    add t4, t3, t4
    
    
    getRandomPointLoop:
        # Obtem-se um numero aleatorio
        jal ra, getRandomPositiveNumber
        
        # Tenta-se colocar o numero obtido entre
        # 0 e 31 (inclusivo)
        rem t1, a0, t0
        
        # Obtem-se outro numero aleatorio
        # e aplica-se o mesmo processo
        jal ra, getRandomPositiveNumber
        rem a1, a0, t0
        
        # Move-se t1 para a0
        mv a0, t1
        
        # Carrega o return address e liberta a
        # memoria previamente alocada no stack point
        sw a0, 0(t3)
        sw a1, 4(t3)
        addi t3, t3, 8
        
        # Verifica se nao ultrapassou o limite maximo
        blt t3, t4, getRandomPointLoop
    
    # Carrega o return address e liberta a memoria
    # previamente alocada no stack point
    lw ra 0(sp)
    addi sp, sp, 4
    jr ra



### getRandomPositiveNumber
# Obtem um numero aleatorio qualquer positivo
# Argumentos: nenhum
# Retorno: nenhum

getRandomPositiveNumber:
    # Aloca memoria e guarda no stack point 
    # o return address para chamada futura
    addi sp, sp, -4
    sw ra 0(sp)
    
    # Carrega do sistema o tempo atual em
    # milisegundos
    li a7, 30
    ecall
    
    mv a2, a0
    
    # Carrega do sistema o numero de ciclos ja
    # executados desde que o programa iniciou
    li a7, 31
    ecall
    
    # Criar caos para aleatorizar o numero
    # obtido anteriormente
    slli a2, a2, 2
    xor a0, a2, a0
    slli a3, a0, 7
    xor a0, a0, a3
    srli a3, a0, 3
    xor a0, a0, a3
    slli a3, a0, 11
    xor a0, a0, a3
    srli a3, a0, 5
    xor a0, a0, a3
    srli a3, a0, 16   
    xor a0, a0, a3
    
    # Obtem-se o modulo do numero, para lidar com
    # situacoes em que e negativo
    jal ra, Abs
    
    # Carrega o return address e liberta a memoria
    # previamente alocada no stack point
    lw ra 0(sp)
    addi sp, sp, 4
    
    jr ra
    
### Abs
# Dado um numero qualquer, obtem o seu modulo
# Argumentos:
# a0: Numero inteiro
# Retorno: nenhum

Abs:
    # Verifica se o numero e menor ou igual a 0
    bltz a0, Negate
    jr ra
    
    Negate:
        # Inverte o valor para positivo,em
        # complemento para 2
        neg a0, a0
        jr ra
    
### manhattanDistance
# Dado um numero qualquer, obtem o seu modulo
# Argumentos:
# a0: x do ponto
# a1: y do ponto
# a2: x do centroid
# a3: y do centroid
# Retorno: nenhum
manhattanDistance:
    # Aloca memoria e guarda no stack point 
    # o return address para chamada futura
    addi sp, sp, -8
    sw ra 0(sp)
    
    # Subtrai a coordenada x do centroid com a x
    # do ponto do cluster
    sub a0, a0, a2
    
    # Obtem-se a diferenca em modulo
    # e guarda-se no stack point
    jal ra, Abs
    sw a0, 4(sp)
    
    # Subtrai a coordenada y do centroid com a y
    # do ponto do cluster
    sub a0, a1, a3
    jal ra, Abs
    
    # Move-se o novo valor obtido para a1
    mv a1, a0
    
    # Carrega-se o valor guardado no stack point
    # e soma-se as distancias
    lw a0, 4(sp)
    add a0, a0, a1
    
    # Carrega o return address e liberta a memoria
    # previamente alocada no stack point
    lw ra, 0(sp)
    addi sp, sp, 8
    jr ra
    
    
### nearestCLuster
# Encontra o cluster mais proximo de um dado ponto
# Argumentos:
# a0: x do ponto
# a1: y do ponto
# Retorno: nenhum
nearestCLuster:
    # Aloca memoria e guarda no stack point 
    # o return address para chamada futura e
    addi sp, sp, -12
    sw ra 0(sp)
    
    # Guarda-se a coordenada do ponto no stack
    # point (x,y)
    sw a0 4(sp)
    sw a1 8(sp)
    
    # Carrega o endereco do vetor dos centroids
    la t0, centroids
    
    # Define-se a distancia maxima e minima
    li t1, 62
    li t3, -1
    
    # Carrega k do stack point e multiplica-o
    # por 8
    li t2, 3
    slli t2, t2, 3
    
    # Atualiza o endereco para apontar 3 posicoes
    # mais a frente
    add t2, t0, t2
    
    nearestCLusterLoop:
        # Incrementa 1 ao valor do cluster
        addi t3, t3, 1
        
        # Carrega a coordenada do centroid do
        # stack point
        lw a2, 0(t0)
        lw a3, 4(t0)
        
        # Carrega a coordenada do ponto do stack
        # point (x,y)
        lw a0 4(sp)
        lw a1 8(sp)
        
        # Avanca 3 posicoes no vetor dos centroids
        addi t0, t0, 8
        
        # Calcula a distancia manhattan entre o
        # centroid e o cluster
        jal ra, manhattanDistance
        
        # Verifica se a distancia e menor relativamente
        # a outro cluster
        ble a0, t1, ReplaceNearest
        
        # Verifica se nao ultrapassou o limite maximo
        blt t0, t2, nearestCLusterLoop
        
        j fim
        
        ReplaceNearest:
            # Substitui a distancia anterior
            # pela atual que e mais pequena
            mv t1, a0
            mv t4, t3
            
            # Verifica se nao ultrapassou o limite maximo
            blt t0, t2, nearestCLusterLoop
    
    fim:
        mv a0, t4
        
        # Carrega o return address e liberta a memoria
        # previamente alocada no stack point
        lw ra, 0(sp)
        addi sp, sp, 12
        jr ra  
        
        
        
    
    