#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas nécessaire de les modifier.!!!

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# on ajoute les couleurs du rainbow
rainbow: .word 0x000000ff, 0x008B0000, 0x00ff6800, 0x00ffff00, 0x00b600ff, 0x0000ffcd, 0x0040E0D0, 0x00FFC0CB, 0x009400D3
.eqv blue 0
.eqv darkRed   4
.eqv orange 8
.eqv yellow  12
.eqv violet  16
.eqv blue2 20
.eqv turquoise 24
.eqv pink 28
.eqv violet2 32

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille # On charge taille Grille dans le registre $t0
mul $t0 $a1 $t0 # Multiplication de position de X fois la taille de grille
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 16
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)
sw $t2, 12($sp)

lw $s0 tailleSnake

sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4
li $t2, 0
PSLoop:
bge $s1 $s0 endPSLoop
blt $t2, 20, continue
li $t2, 0
continue:

# On genere un nombre aleatoire entre 0 et taille du tableau rainbow ( qui est de 6 ici mais elle peut augmenter si on ajoute des nouvelles couleurs)
# comme la couleur du serpent change � chaque iteration
# On genere le nombre al�atoire grace au syscall avec v0 = 42,	
genRand:
li $a1, 9
li $v0, 42
syscall

move $t2, $a0
mul $t2 ,$t2, 4

Paint:
lw $a0 rainbow($t2)
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
addi $s1 $s1 4
addi $t2, $t2, 4
sll $s1, $s1, 1

j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
lw $t2, 16($sp)
addu $sp $sp 16
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
or $t0 0x2
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIdroite
li $t1 122
beq $t0 $t1 GIgauche
li $t1 113
beq $t0 $t1 GIbas
li $t1 100
beq $t0 $t1 GIhaut
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

#jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4


# Boucle de jeu

mainloop:
jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame

#vitesse du snake
li $a0 500
lw $t0 scoreJeu
li $t1 20
mul $t0 $t0 $t1
sub $a0 $a0 $t0

jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 0         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

#Message
veryBadGame: .asciiz "??????????? tu trolls gros"
badGame: .asciiz "bon t'es vraiment claqu� on va faire comme si on a rien vu ok?\ntiens ton score et d�gage je veux plus te voir : "
okGame: .asciiz "ca va c'est ok tier mais bon tu peux faire mieux\nTon score : "
goodGame: .asciiz "t'es chaud t'es chaud\nTon score : "

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire un demi-tour 
#                 (se retourner en un seul tour. Par exemple passer de la 
#                 direction droite à gauche directement est impossible (un 
#                 serpent n'est pas une chouette)
################################################################################

majDirection:

# En haut, ... en bas, ... à gauche, ... à droite, ..


lw $t0 snakeDir #on charge snakeDir dans le registre $t0

add $t1 $t0 $a0 # On additionne la direction actuelle avec l'argument passé à cette fonction
li $t2 2
div $t1 $t2 #S
mfhi $t3 # on prend le reste de la division


if: beq $t3, $0, else # Si le reste de la division est égal à zéro (flèche contraire), on saute cette condition.
sw $a0, snakeDir

else:  

jr $ra


############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
# jal hiddenCheatFunctionDoingEverythingTheProjectDemandsWithoutHavingToWorkOnIt

addi $sp $sp -4
sw $ra 0($sp)

Queue: 
lw $t0, tailleSnake # on charge la taille Snake dans le registre $t0
la $t1, snakePosX # on charge l'adresse du snakePosX dans $t1
la $t2, snakePosY #on charge l'adresse du snakePosY dans $t2
li $t5 4
subi $t6 $t0 1 # taillesnake - 1

li $t7, 0 #index   

loop: beq $t7, $t0, Tete #Tant que l'index dans le registre $t7 n'est pas égal à 0, on continue la boucle

#De la queue jusqu'à le bout du corps du snake avant sa tête
mul $t8 $t6 $t5
addu $t9, $t8, $t1

lw $t4 0($t9) # snakePosX
sw $t4 4($t9) # pixel fantôme

addu $t3, $t8, $t2  
lw $t4, 0($t3) # snakePosY
sw $t4 4($t3) # pixel fantôme

addi $t7 $t7 1 # incrémentation de l'index de la boucle
subi $t6 $t6 1
j loop

Tete:
	
lw $a0 snakeDir

# NB : x et y sont inverés , (voir explication dans la partie 1 du rapport)

droite:bne $a0 0 gauche # premier cas si $a0 = 0 (droite), on ne saute pas
lw $t1 snakePosY($0)
addi $t1 $t1 1
sw $t1 snakePosY($0) # On sauvegarde la poistionY + 1 dans la tête du snake
j candyUpdate
    		
gauche: bne $a0 2 haut # deuxième cas si $a0 = 2 (gauche), on ne saute pas
lw $t1 snakePosY($0)
subi $t1 $t1 1
sw $t1 snakePosY($0) # On sauvegarde la positionY - 1 dans la tête du snake
j candyUpdate

haut:bne $a0 1 bas # troisième cas si $a0 = 1 (haut), on ne saute pas
lw $t1 snakePosX($0)
addi $t1 $t1 1
sw $t1 snakePosX($0) # On sauvegarde la positionX + 1 dans la tête du snake
j candyUpdate
    		
bas: # dernier cas si $a0 = 3 (bas)
lw $t1 snakePosX($0)
subi $t1 $t1 1
sw $t1 snakePosX($0) # On sauvegarde la positionX - 1 dans la tête du snake
j candyUpdate


candyUpdate:
addi $sp $sp -4
sw $ra 0($sp)

# On charge toutes les choses nécessaire à la position du candy dans des registres temporaires

lw $t1, snakePosX($0)
lw $t2, snakePosY($0)
lw $t3 candy
lw $t4 candy + 4
lw $t5 tailleSnake
li $t6 4

candyCheck:
bne $t1 $t3 finupdate # On vérifie si la position de la tête du snake est celle du bonbon
bne $t2 $t4 finupdate

jal newRandomObjectPosition # Fonction qui renvoie des positions X et Y aléatoires
sw $v0 candy # On sauvegarde la position X retournée par la fonction random dans Pos X de candy
sw $v1 candy + 4 # On sauvegarde la position Y retournée par la fonction random dans Pos Y de candy

lw $t0 scoreJeu
addi $t0 $t0 1 # On incrémente le score du jeu
sw $t0 scoreJeu # On le sauvegarde dans scoreJeu


addi $t5 $t5 1 # On incrémente la taille du snake et on la sauvegarde dans tailleSnake
sw $t5 tailleSnake


Obstacles:

jal newRandomObjectPosition # Fonction qui renvoie des positions X et Y aléatoires

lw $t0, scoreJeu
sw $t0, numObstacles # Il y a autant d'obstacles que de points dans le score du jeu, donc on sauvegarde le score dans numObstacles
la $t1, obstaclesPosX
la $t2, obstaclesPosY
li $t6 4

mul $t3 $t0 $t6 

addu $t4, $t3, $t1 # permet d'atteindre la position x de l'obstacle voulu

addu $t5, $t3, $t2 # permet d'atteindre la position y de l'obstacle voulu

sw $v0, 0($t4) # On sauvegarde la position X renvoyée par la fonction random dans l'adresse de la position X de l'obstacle voulu
sw $v1, 0($t5) # On sauvegarde la position Y renvoyée par la fonction random dans l'adresse de la position Y de l'obstacle voulu

jal printObstacles # permet d'afficher les obstacles


finupdate:

lw $ra 0($sp)
addi $sp $sp 4

jr $ra


############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:

li $v0 0
lw $t0 snakePosX($0)
lw $t1 snakePosY($0)
lw $t2 tailleSnake

border: # Si la tête du snake touche une bordure, on met fin au jeu.
beq $t0 16 failure 
beq $t1 16 failure
beq $t0 -1 failure
beq $t1 -1 failure


beq $t2 1 FinJeu # S'il n'y a que la tête du snake, on a pas besoin de vérfier les deux autres conditions de fin du jeu.

autofeed: # On vérifie si la tête du snake touche une partie de son corps.
li $t4 4
li $t5 1

whileautofeed: beq $t5 $t2 crashObstacle # On sort de cette boucle pour passer à la dernière condition de fin de jeu seulement si la tête du Snake ne touche pas son corps.
mul $t9 $t5 $t4
lw $t6 snakePosX($t9)
lw $t7 snakePosY($t9)
bne $t0 $t6 incrementautofeed # si la position X de la tête du snake n'est pas égale à celle d'un bout de son corps, on continue la boucle
beq $t1 $t7 failure # si la position Y est celle d'un bout de son corps, on met fin au jeu et on sort de la boucle.

incrementautofeed: # Incrémentation du i de la boucle de vérification
addi $t5 $t5 1
j whileautofeed


crashObstacle:
lw $t2, numObstacles
li $t5, 0 

whilecrashObstacle: beq $t2 $t5 FinJeu # Si la tête du snake ne touche aucun obstacle, on continue le jeu

mul $t9 $t5 $t4 # On accède à chaque obstacle
lw $t6 obstaclesPosX($t9)
lw $t7 obstaclesPosY($t9)

bne $t0 $t6 incrementcrashObstacle # On vérifie si la position X de la tête du snake est celle de l'obstacle pointée
beq $t1 $t7 failure # On vérifie si la position Y de la tête du snake est celle de l'obstacle pointée

incrementcrashObstacle: # Incrémentation pour faire continuer la boucle while
addi $t5 $t5 1
j whilecrashObstacle


failure: # On met fin au jeu (défaite)
li $v0 1

FinJeu:
jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation!»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:

li $v0, 4
lw $a0, scoreJeu
blt $a0, 1, veryBadMessage # Si le score est inférieur à 1
blt $a0, 5, badMessage # si le score est égale ou supérieur à 1 et est inférieur à 5
blt $a0, 10, okMessage # si le score est inférieur à 10 mais au dessus ou égal à 5

goodMessage: # Sinon si le score est supérieur ou égal à 10
la $a0, goodGame
syscall
j printScore

veryBadMessage:
la $a0, veryBadGame
syscall
j fin

badMessage:
la $a0, badGame
syscall
j printScore

okMessage:
la $a0, okGame
syscall
j printScore

GoodMessage:
la $a0, goodGame
syscall

printScore:
li $v0, 1
lw $a0, scoreJeu
syscall
li $v0, 10
syscall

fin:
jr $ra
