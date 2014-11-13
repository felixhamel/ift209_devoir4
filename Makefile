#Makefile pour le tp4, ift249 automne 2006
#auteur: Mikael Fortin, octobre 2006





normal:	tp4.o affiche.o lecture.o verifie.o solution.o position.o debut.o suivant.o indicateur.o
	@echo
	@echo ----------------------------------------------
	@echo Executable final  !! AVEC LA LIBRAIRIE DE C !!
	@echo ----------------------------------------------
	@echo
	
	ld -e Main tp4.o affiche.o lecture.o verifie.o solution.o position.o debut.o suivant.o indicateur.o -o tp4 -lc
	
     
debug:	tp4debug.o affiche.o lecture.o verifie.o solution.o position.o debut.o suivant.o indicateur.o
	@echo
	@echo ------------------------------------------------------------------------
	@echo Executable final  !! AVEC LA LIBRAIRIE DE C: DEBOGAGE, AUCUNE LECTURE !!
	@echo ------------------------------------------------------------------------
	@echo
	
	ld -e Main tp4debug.o affiche.o lecture.o verifie.o solution.o position.o debut.o suivant.o indicateur.o -o tp4 -lc

debugtrap:	tp4trapdebug.o affichetrap.o lecturetrap.o verifietrap.o solution.o position.o debut.o suivant.o indicateur.o
	@echo
	@echo ------------------------------------------------------------------------
	@echo Executable final  !! AVEC LES APPELS SYSTEME: DEBOGAGE, AUCUNE LECTURE !!
	@echo ------------------------------------------------------------------------
	@echo
	
	ld -e Main tp4trapdebug.o affichetrap.o lecturetrap.o verifietrap.o solution.o position.o debut.o suivant.o indicateur.o -o tp4trap    
    
tp4.o: tp4.as
	gas -Av8 tp4.as -o tp4.o
	
affiche.o: affiche.as	
	gas -Av8 affiche.as -o affiche.o
     
lecture.o: lecture.as     
	gas -Av8 lecture.as -o lecture.o
     
verifie.o: verifie.as
	gas -Av8 verifie.as -o verifie.o
   
   
   
trap: 	tp4trap.o affichetrap.o lecturetrap.o verifietrap.o solution.o debut.o suivant.o indicateur.o position.o
	@echo
	@echo -----------------------------------------------
	@echo Executable final  !! AVEC LES APPELS SYSTEME !!
	@echo -----------------------------------------------
	@echo
	
	ld -e Main tp4trap.o affichetrap.o lecturetrap.o verifietrap.o solution.o position.o debut.o suivant.o indicateur.o -o tp4trap 
     
     
tp4trap.o: tp4trap.as
	gas -Av8 tp4trap.as -o tp4trap.o
	
affichetrap.o: affichetrap.as	
	gas -Av8 affichetrap.as -o affichetrap.o
     
lecturetrap.o: lecturetrap.as     
	gas -Av8 lecturetrap.as -o lecturetrap.o

verifietrap.o: verifietrap.as
	gas -Av8 verifietrap.as -o verifietrap.o
       
     
     
clean: 
	@echo -----------------------------------------
	@echo Effacement des fichiers intermediaires...
	@echo -----------------------------------------
	rm -rf *.o
	rm -rf tp4
	rm -rf tp4trap
	rm -rf testposition
	rm -rf testdebut
	rm -rf testsuivant
	rm -rf testindicateurs
   

testposition: 	testposition.o position.o
	@echo
	@echo -----------------------------------------------
	@echo Test pour la fonction Position
	@echo -----------------------------------------------
	@echo
	
	ld -e TestPosition testposition.o position.o -o testposition -lc
	#testposition

testdebut: 	testdebut.o debut.o
	@echo
	@echo -----------------------------------------------
	@echo Test pour la fonction Debut
	@echo -----------------------------------------------
	@echo
	
	ld -e TestDebut testdebut.o debut.o -o testdebut -lc
	#testdebut
	
testsuivant: 	testsuivant.o suivant.o
	@echo
	@echo -----------------------------------------------
	@echo Test pour la fonction Suivant
	@echo -----------------------------------------------
	@echo
	
	ld -e TestSuivant testsuivant.o suivant.o -o testsuivant -lc
	#testsuivant
	
	
testindicateurs: testindicateurs.o indicateur.o
	@echo
	@echo -----------------------------------------------
	@echo Test pour les fonctions reliees aux indicateurs
	@echo -----------------------------------------------
	@echo
	
	ld -e TestIndicateurs testindicateurs.o indicateur.o -o testindicateurs -lc
	#testindicateurs
	
position.o: position.as
	gas -Av8 position.as -o position.o
	
testposition.o: testposition.as
	gas -Av8 testposition.as -o testposition.o
	
solution.o: solution.as
	gas -Av8 solution.as -o solution.o
 
debut.o: debut.as
	gas -Av8 debut.as -o debut.o	 
 
testdebut.o: testdebut.as
	gas -Av8 testdebut.as -o testdebut.o 
	
suivant.o: suivant.as
	gas -Av8 suivant.as -o suivant.o
	
testsuivant.o: testsuivant.as
	gas -Av8 testsuivant.as -o testsuivant.o
	
indicateur.o: indicateur.as
	gas -Av8 indicateur.as -o indicateur.o

testindicateurs.o: testindicateurs.as
	gas -Av8 testindicateurs.as -o testindicateurs.o
	
tp4debug.o: tp4debug.as
	gas -Av8 tp4debug.as -o tp4debug.o

tp4trapdebug.o: tp4trapdebug.as
	gas -Av8 tp4trapdebug.as -o tp4trapdebug.o
