/*

Tp4, fonction d'affichage
Cette fonction parcourt une matrice de 81 octets contenant des valeurs de 0 a 9.
Elle affiche les valeurs ainsi qu'un ensemble de separateurs pour lui donner
l'aspect d'un sudoku.

Entrees: %i0, adresse de la matrice.
Sorties: aucune


Auteur: Mikael Fortin, septembre 2006
*/


.global Affiche


.section ".text"

Affiche:
		save	%sp,-96,%sp			! sauvegarde l'environnement de l'appelant

		mov		0, %l0								! %l1 contient le numero de la case courante (0 - 80).
		mov		0, %l1								! %l1 contient %l0 modulo 9.
		set   tamponaffichage, %l4	! Espace mémoire pour l'affichage de chaque chiffre
		mov	  ' ', %l5							! Espace pour affichage (caractère)

		set		separator, %o0	! affiche un premier separateur
		call 	printf					! ...
		mov		0, %l2					! initialise %l0, compteur de lignes

		set		vertline, %o0		! affiche la premier ligne verticale de la premiere ligne
		call	printf					! ...
		mov		0, %l3					! %l3 contient %l0 modulo 3.


		/*
			Lecture et affichage d'une case
		*/

aff00:
		ldub	[%i0+%l0], %o1		! Lecture de la case courante

		add		%o1, '0', %o1			! Transformation en caractere
		cmp		%o1, '0'					! Verifie si le resultat est '0'
		bne		aff10							! Different de '0', traitement normal
		nop											! ...

		mov		32, %o1					! Caractere d'espace si c'est 0


aff10:
		!cmp		%o1, 10					! Si on fait fasse a un NewLine, on avance a la prochaine valeur du Sudoku
		!be		aff00
		!inc		%i0

		stb		%l5, [%l4]				! Affiche un espace
		mov		%l4, %o0
		call	printf
		nop

		stb		%o1, [%l4]			! Mettre le chiffre dans le tampon d'affichage
		mov		%l4, %o0				! Format qui affiche un caractere, le nombre
		call	printf					! Affichage de la case courante
		nop										! ...

		stb		%l5, [%l4]				! Affiche un espace
		mov		%l4, %o0
		call	printf
		nop

		cmp	%l3, 2						! verifie si on aura un multiple de 3
		bne	aff15							! sinon, aucun traitement special
		inc	%l3								! incremente le modulo 3


		/*
			Traitement special pour chaque trois cases: affiche une ligne verticale
		*/

		set	vertline,%o0		!format de la ligne verticale
		call	printf			!affiche la ligne verticale
		mov	0,%l3			!ramene le compteur a 0: multiple de 3 modulo 3 = 0.

aff15:
		cmp	%l1,8			!verifie si on aura un multiple de 9
		bne	aff30			!sinon, aucun traitement special
		inc	%l1			!incremente le modulo 9


		/*
			Traitement special pour chaque 9 cases (fin de ligne)
			Affiche un saut de ligne
		*/

		set 	linefeed,%o0		!prepare l'affichage d'un saut de ligne
		call	printf			!change de ligne apres 9 cases
		mov	0,%l1			!ramene le compteur a 0: multiple de 9 modulo 9 = 0.

		inc	%l2			!incremente le compteur de lignes

		cmp	%l2,3			!a-t-on parcouru 3 lignes?
		bne	aff20			!sinon, aucun traitement special
		nop
						!...

		/*
			Traitement special a toutes les trois lignes (27 cases), affiche un separateur.
		*/

		set		separator, %o0		!on a parcouru 3 lignes, on doit donc afficher un separateur
		call	printf			!affiche le separateur
		mov		0,%l2			!reinitialise le compteur de lignes.


		/*
			Traitement special, fin de la matrice.
		*/

aff20:
		cmp		%l0, 80					! A-t-on affiche la derniere case?
		be		aff30						! si oui, on n'affiche pas la ligne verticale qui commence la ligne suivante
		nop										! ...
		set		vertline, %o0		! Affiche la premiere ligne verticale de la ligne suivante.
		call	printf					! ...
		nop										! ...


		/*
			Test de fin et gestion de l'index
		*/

aff30:
		inc	%l0			!avance a la case suivante
		cmp	%l0,81			!Si n'a pas depasse la fin du tableau
		bl	aff00			!passe a la case suivante
		nop				!...


		call	fflush			!vide les tampons
		mov	0,%o0			!...

		ret				!retour a l'appelant
		restore				!retablit l'environnement de l'appelant



.section ".rodata"

linefeed:	.asciz "\n"
prntnum:	.asciz " %c "
prntnum2:	.asciz "%d "
separator:	.asciz "|---------|---------|---------|\n"
vertline:	.asciz "|"

.section ".data"
  tamponaffichage:  .byte   	0   ! Espace pour l'affichage
