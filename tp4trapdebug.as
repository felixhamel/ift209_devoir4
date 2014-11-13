
/* Solution tp3, version premliminaire */

.global Main


.section ".text"


Main:		set 	ptfmt1,%o0		!imprime le message d'en-tete
		call	printf			!...
		nop				!...
		
		
				
		
		/*	
			Lecture des 81 cases du sudoku
		*/		
		
		set	Sudoku3,%l7		!place l'adresse du sudoku dans %l7
		!call	Lecture			!remplit le sudoku avec des valeurs
		!mov	%l7,%o0			!premier parametre: adresse du sudoku
		
		call	Affiche			!Affiche le sudoku
		mov	%l7,%o0			!Premier parametre, adresse du sudoku
		
		
		call	Solve			!solutionne le sudoku
		mov	%l7,%o0			!premier parametre: adresse du sudoku
		
		
		set	ptfmt2,%o0		!message de solution
		call	printf
		nop
		
		call	Affiche			!affiche le sudoku solutionne
		mov	%l7,%o0			!premier parametre: adresse du sudoku
		
		call	Verifie			!verifie si le sudoku a des erreurs
		mov	%l7,%o0			!premier parametre: adresse du sudoku.
		
		
		
		call	fflush			!vide les tampons
		mov	0,%o0
		
		call	exit			!fin du programme
		mov	0,%o0			!...
		
				
		
		
		
		
.section ".rodata"

ptfmt1:		.asciz "Verificateur / Solutionneur de Sudoku v0.01b\n"
ptfmt2:		.asciz "Solution:\n"

.section ".bss"

sudoku: .skip 81
	


.section ".data"
Sudoku3:
.byte 8,3,2,5,9,1,6,7,4,4,9,6,3,8,7,2,5,1,5,7,1,2,6,4,9,8,3,1,8,5,7,4,6,3,9,2,2,6,7,9,5,3,4,1,8,9,4,3,8,1,2,7,6,5,7,1,4,6,3,8,5,2,9,3,2,9,1,7,5,8,4,6,6,5,8,4,2,9,1,3,7,7
