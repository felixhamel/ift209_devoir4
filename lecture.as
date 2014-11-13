/*

Lecture: fonction qui lit les 81 cases du sudoku.

Entrees: %i0, adresse du sudoku a emplir.


Auteur: Mikael Fortin, septembre 2006

*/	



	
	
.global Lecture		



		
		
		
Lecture:	save	%sp,-96,%sp		!sauvegarde l'environnement de l'appelant
		set	tampon, %l0		!place l'adresse du tampon de lecture dans %l0		
			
		mov	0,%l6			!numero de case commence a 0
		
		/*
			Boucle qui lit chacune des cases
		*/		
lect00:		set	scfmt1, %o0		!preparaction du format de lecture
		call 	scanf			!lecture
		mov	%l0,%o1			!place le tampon de lecture en parametre
		
		ld	[%l0],%l1		!recupere la donnee
		stb	%l1,[%i0+%l6]		!ecrit la donnee dans le sudoku
		
		
		cmp	%l6,81			!fin de la lecture?
		bl	lect00			!continue sinon
		inc	%l6			!incremente la position dans le tableau
		
		
		ret				!retour a l'appelant
		restore				!retablit l'environnement de l'appelant
		
		
.section ".rodata"

scfmt1: 	.asciz "%d"



.section ".bss"

	.align 4
tampon:	.skip 4
