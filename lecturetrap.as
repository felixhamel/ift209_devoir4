/*

Lecture: fonction qui lit les 81 cases du sudoku.

Entrees: %i0, adresse du sudoku a emplir.


Auteur: Mikael Fortin, septembre 2006

*/

.global Lecture


Lecture:
	save	%sp,-96,%sp			! sauvegarde l'environnement de l'appelant
	set		tampon, %l0			! place l'adresse du tampon de lecture dans %l0

	mov		0, %l6					! numero de case commence a 0


/*
	Boucle qui lit chacune des cases
*/
lect00:
	mov		3, %g1			! Lecture
	clr		%o0					! Lecture dans stdint
	mov		%l0, %o1		! Tampon d'écriture
	mov		1, %o2			! Nombre de caractère(s) à lire
	ta		0x8

	ldub 	[%l0], %l1			! recupere la donnee

	cmp		%l1, 48					! Si on détecte un retour de ligne, on le skip
	bl		lect20
	nop

	sub		%l1, '0', %l1		! Transformer le caractère en numéro
	stb		%l1, [%i0+%l6]	! ecrit la donnee dans le sudoku

lect10:
	cmp		%l6, 81					! fin de la lecture?
	bl		lect00					! continue sinon
	inc		%l6							! incremente la position dans le tableau

	ret										! retour a l'appelant
	restore								! retablit l'environnement de l'appelant

lect20:
	cmp		%l6, 81					! Si on a nos 81 chiffres, on passe a la suite
	be		lect10
	nop

	ba		lect00					! Sinon on continue la lecture
	nop

.section ".bss"
						.align 4
	tampon:		.skip 1			! Espace pour la lecture du chiffre en entrée
