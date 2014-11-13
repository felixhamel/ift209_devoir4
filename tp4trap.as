
/* Solution tp3, version preliminaire */

.global Main
.global printf
.global scanf
.global fflush
.global exit

.section ".text"

/*
	Affichage du texte à l'écran.

	Reçoit en paramètre:
		- %i0 = Texte (ADDR)
		- %i1-i7 -> Parametres
 */
printf:
	save	%sp,-96,%sp

  mov		%i0, %o0		! Calculer la longueur de la string
	call	sizeofs
	nop

	mov		4, %g1			! Affichage
	mov		1, %o0			! Écriture dans stdout
	mov		%o1, %o2		! Nombre de caractère(s)
	mov		%i0, %o1		! Adresse du texte a lire
	ta		0x8

	ret
	restore

/*
	Lit au clavier et écrit dans le tampon d'écriture

	Reçoit en paramètre:
		- %i0 = Tampon de lecture (ADDR)
		- %i1 = Nombre de caractères a lire
 */
scanf:
	save	%sp,-96,%sp

	mov		3, %g1			! Lecture
	clr		%o0					! Lecture dans stdint
	mov		%i0, %o1		! Tampon d'écriture
	mov		%i1, %o2		! Nombre de caractère(s) à lire
	ta		0x8

	ret
	restore

/*
	Vider les tampons et fermer tous les fichiers ouverts
 */
fflush:
	save	%sp,-96,%sp

	mov		6, %g1			! Fflush
	mov		0, %o0

	ta		0x8

	ret
	restore

/*
	Sortie du programme.
 */
exit:
	save	%sp,-96,%sp

	mov		1, %g1			! Sortie du programme
	mov		0, %o0			!

	ta		0x8

	ret
	restore

/*
	Trouve la longueur de la chaine de caractère.

	Entrée: %i0 = Texte
	Sortie: %i1 = Longueur
*/
sizeofs:
	save	%sp,-104,%sp
	clr		%i1								! Remettre i1 a 0

findlength:
	ldub	[%i0+%i1], %l0		! Charger en mémoire
  cmp   %l0, 0						! Si on a pas atteint la valeur nulle, on continue
	bne		findlength
	inc		%i1								! On passe a l'autre lettre

finsizeofs:
	ret											! Fin du compteur
	restore



Main:
		set 	ptfmt1,%o0		!imprime le message d'en-tete
		call	printf
		nop

		/*
			Lecture des 81 cases du sudoku
		*/

		set	sudoku, %l7		!place l'adresse du sudoku dans %l7
		call	Lecture			!remplit le sudoku avec des valeurs
		mov	%l7,%o0			!premier parametre: adresse du sudoku

    !set  sudoku, %o0
		!call printf
		!nop

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

sudoku: .skip 200
