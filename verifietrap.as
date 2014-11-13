/*

Fonction Verifie

Cette fonction verifie si un sudoku est valide.
Elle supporte les valeurs 0 a 9 dans le sudoku, la valeur 0 representant une case vide.
Une case vide est considere comme une erreur.
Afin de savoir quels chiffres on a vus en parcourant une zone (ligne colonne ou bloc), un registre contient
des bits indicateurs.  Un parcous correct en est un ou on voit tous les chiffres sauf 0.
Chaque bit de l'indicateur (bits 0 a 9) correspond a un chiffre.
Si le chiffre est rencontre, le bit change de valeur.
Un parcours correct d'une zone donnera les vaeurs suivantes pour les bits

1111111110

Les chiffres 1 a 9 sont vus, mais pas 0.
Toute autre valeur indique une zone qui contient une erreur (chiffre double, chiffre manquant, case vide).

La fonction parcourt d'abord les lignes, ensuite les colonnes et finalement les blocs.
Pour arriver a calculer la case suivante dans le bon ordre, elle fait appel a la fonction suivant.
A chaque fois que 9 cases sont parcourues, une zone a ete visitee, on verifie donc si elle comportait des erreurs.

Entrees: %i0, adresse du tableau contenant le sudoku

Sorties: aucune

Auteur: Mikael Fortin, septembre 2006
*/





.global Verifie



Verifie:
		save	%sp,-96,%sp

		/*
			Construction d'un tableau d'index pour les types de parcours
			Utilise pour l'affichage d'erreurs, contient des pointeurs vers
			les chaines de caractere aux symboles "region1" et suivants.
			C'est un exemple d'adressage indirect.
		*/

		set	redir,%l0		!adresse du tableau d'index
		set 	region1,%l1		!adresse de la chaine "la rangee"
		st	%l1,[%l0]		!place l'adresse de la chaine "la rangee" au premier index
		set	region2,%l1		!adresse de la chaine "la colonne"
		st	%l1,[%l0+4]		!place l'adresse de la chaine "la colonne" au second index
		set	region3,%l1		!adresse de la chaine "le bloc"
		st	%l1,[%l0+8]		!place l'adresse de la chaine "le bloc" au troisieme index



		mov	0,%y
		mov	0,%l0			!no de case courante
		mov	0,%l1			!compteur, nombre de cases visitees
		mov	1,%l2
		mov	0,%l6			!registre contenant les indicateurs:les bits 0 a 9 representent chaque chiffre
		mov	0x3FE,%l5		!valeur d'un parcours correct: tous les bits allumes sauf 0; indicateur final.
		mov	0,%l4
		mov	0,%l3


Verif00:
		ldub	[%i0+%l0],%l7		!lecture de la case courante

		sll	%l2,%l7,%l7		!valeur 1 decalee de la valeur de la case
		xor	%l7,%l6,%l6		!allume ou eteint le bit correspondant dans le registre d'indicateurs

		cmp	%l1,8			!verifie si on a fini de parcourir une zone (9 cases, 0 a 8)
		bne	Verif05			!sinon, traitement normal
		inc	%l1			!une case de plus de traitee

		inc	%l3			!
		mov	0,%l1			!recommence a 0 cases visitees
		and	%l6,%l5,%l5		!si un des bits de l'indicateur de cette zone est a 0,
						!un bit de l'indicateur final sera eteint...
		cmp	%l6,0x3FE		!verifie si l'indicateur courant est valide (tous les chiffres presents une fois)
		be	Verif05			!si oui, aucune affichage d'erreur
		mov	0,%l6			!reinitialise l'indicateur de zone courante


		mov	%l3,%o2			!place le no de zone dans %o2, deuxieme parametre d'impression

		cmp	%l4,2			!si le parcours etait par blocs, les coordonnees ne sont pas correctes
		bne	Verif03			!sinon, les coordonnees ne doivent pas etre manipulees
		nop				!...

		!flip coordonnees: le no de bloc est incorrect, ceux-ci sont parcourus dans le mauvais ordre
		!ce segment de code calcule le vrai no de bloc a partir du no utilise pour le parcours.

Verif01:
		sub	%l3,1,%g3
		udiv	%g3,3,%g1
		umul	%g1,3,%g2
		sub	%g3,%g2,%g2
		umul	%g2,3,%g2
		add	%g2,%g1,%o2
		inc	%o2

		/*
			Affichage du message d'erreur
		*/

Verif03:
		set 	ptfmt2, %o0				! message d'erreur
		call	printf						! affiche le message
		nop											! ...

		! Afficher le type de validation
		set		redir, %o1
		sll		%l4, 2, %g5				! type de parcours * 4 = index de la sous-chaine
		ld		[%o1+%g5], %o1		! recupere l'adresse de la sous-chaine
		mov		%o1, %o0
		call	printf
		nop

		! Afficher un espace
		set		espace, %o0
		call	printf
		nop

		! Afficher la valeur
		set		tamponaffichage, %o0
		add		%o2, '0', %o3
		stb		%o3, [%o0]
		call	printf
		nop

		! Afficher un retour de ligne
		set		ptfnl, %o0
		call	printf
		nop

		/*
			Ce segment de code obtient le no de la case suivante selon le type de parcours.
		*/
Verif05:
		cmp	%l0,80			!A-t-on termine le parcours?
		bge	Verif07			!si oui, on change le type de parcours
		nop				!...

		mov	%l0,%o0			!premier parametre: no de case courante
		call	Suivant			!sous-programme qui calcule la case suivante
		mov	%l4,%o1			!deuxieme parametre: type de parcours
		mov	%o0,%l0			!recupere la case suivante et la copie dans %l0, nouvelle case courante
		ba	Verif00			!continue le parcours
		nop				!...


		/*
			Gestion du changement de parcours
		*/

Verif07:
		mov	0,%l0			!recommence le parcours a la case 0
		mov	0,%l6			!l'indicateur courant est reinitialise
		mov	0,%l3			!no de zone est reinitialise
		cmp	%l4,2			!a-t-on fait le dernier type de parcours?
		bl	Verif00			!sinon, on peut faire le parcours suivant
		inc	%l4			!parcours suivant...


		set	ptfmt3,%o0		!impression d'un message de reussite global
		cmp	%l5,0x3FE		!si l'indicateur global est correct
		be	Verif10			!on ne change pas le message
		nop				!...

		set	ptfmt4,%o0		!change le message pour un message d'erreur

Verif10:
		call	printf			!affiche le message
		nop				!...

		ret				!retour a l'appelant
		restore				!ramene l'environnement de l'appelant




/*

Fonction Suivant

Calcule la case suivante dans une matrice 9x9, selon le type de parcours.
Le tpye de parcours peut etre par lignes, colonnes ou blocs (type de zone).
Lorsqu'on a parcouru une zone au complet (une ligne, colonne ou bloc), un traitement
different doit etre parfois applique pour que la case suivante soit bien le debut
de la zone suivante.

Tous les parcours commencent a la case 0 et se terminent a la case 80.
Le parcours de blocs se fait de haut en bas (verticalement) et non pas horizontalement.
Ceci implique que les nos de bloc serontincorrects lors de l'affichage des erreurs
(voir traitement special avant impression).

Entrees: %i0, case courante
	 %i1, type de parcours (0=lignes, 1= colonnes, 2=blocs)

Sorties: %o0, case suivante

Auteur: Mikael Fortin, septembre 2006
*/

Suivant:	save 	%sp,-96,%sp		!sauve l'environnement de l'appelant
		mov	0,%y			!preparation pour la division
		cmp	%i1,0			!parcours par lignes?
		bg	suiv00			!sinon, teste pour le parcours suivant...
		nop				!...

		inc	%i0			!parcours par lignes: on ne fait qu'avancer d'une case directement

		ret				!retour a l'appelant
		restore				!ramene l'environnement de l'appelant

suiv00:		cmp	%i1,1			!Parcours par colonnes?
		bg	suiv10			!Sinon, c'est un parcours par blocs
		nop


		/*
			Ce segment de code traite le parcours par colonnes
		*/

		add	%i0,9,%l1		!case suivante sur la ligne suivante: +9
		udiv	%l1,81,%l3		!%l3 = case / 81
		umul	%l3,81,%l4		!%l4 = case /81 * 81
		sub	%l1,%l4,%l4		!%l5 = modulo (case,81)

		add	%l3,%l4,%i0		!La case suivante apres la derniere ligne est dans la colonne suivante
						!Le reste est le no de colonne si on depasse, si la division donnait 1,
						!on avance d'une colonne.


		ret				!retour a l'appelant
		restore				!ramene l'environnement de l'appelant.

		/*
			Ce segment de code traite le parcours par blocs.
		*/

suiv10:		inc	%i0			!on avance de 1 sur la ligne courante.
		udiv	%i0,3,%l0		!verifie si on a une case multiple de 3
		umul	%l0,3,%l0		!...
		cmp	%i0,%l0			!reste de la division =0  implique multiple de 3
		bne	suiv20			!si pas multiple de 3, aucun traitement special
		nop				!...

		/*
			Traitement special, changement de ligne dans le bloc
		*/

		inc	6,%i0			!multiple de 3: fin d'une ligne du bloc, prochaine case 6 cases plus loin
		cmp	%i0,81			!a-t-on depasse la derniere rangee du tableau?
		bl	suiv20			!Sinon, aucun traitement special
		nop				!...

		/*
			Traitement special, changement de colonne de blocs
		*/

		sub	%i0,81,%i0		!Retourne au debut de la colonne de blocs
		add	%i0,3,%i0		!debut de la colonne de blocs suivante

suiv20:
		ret				!retour a l'appelant
		restore				!ramene l'environnement de l'appelant


.section ".rodata"

ptfmt2:		.asciz "Le sudoku contient une erreur dans "
ptfmt3:		.asciz "Le sodoku est correctement solutionne\n"
ptfmt4:		.asciz "Le sudoku contient des erreurs\n"
ptfnl:		.asciz "\n"
espace:		.asciz " "
region1:	.asciz "la rangee"
region2:	.asciz "la colonne"
region3:	.asciz "le bloc"


.section ".bss"

	.align 4
redir:	.skip 12

.section ".data"
	tamponaffichage:  .byte   	0   ! Espace pour l'affichage
