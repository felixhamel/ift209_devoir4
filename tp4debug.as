
/* Solution tp3, version premliminaire */

.global Main


.section ".text"


Main:		set 	ptfmt1,%o0		!imprime le message d'en-tete
		call	printf			!...
		nop				!...
		
		
				
		
		/*	
			Lecture des 81 cases du sudoku !! AUCUNE LECTURE !! 
		*/		
		
		
		!set	sudoku,%l7		!place l'adresse du sudoku dans %l7
		!call	Lecture			!remplit le sudoku avec des valeurs
		!mov	%l7,%o0			!premier parametre: adresse du sudoku
		
		set	easy1,%l7		!adresse du sudoku deja en memoire
		
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
easy1:
.byte 4,0,0,0,0,0,1,8,0,0,0,8,7,0,0,0,9,0,1,0,3,0,6,0,2,0,4,5,0,9,3,1,4,0,6,0,0,4,0,0,0,0,0,3,0,0,6,0,2,5,7,8,0,9,9,0,6,0,7,0,4,0,8,0,5,0,0,0,2,9,0,0,0,1,7,0,0,0,0,0,3,3
