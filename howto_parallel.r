#
# Parallels Rechnen mit R auf Multicore Prozessoren
#
# siehe auch: http://www.rparallel.org
#-------------------------------------------------------------------------------

# package nicht auf CRAN verfügbar, bei http://www.rparallel.org downloaden
library(rparallel)


#---
# Funktion mit Schlaufe zum parallelisieren
#---

test = function (x, n=4, parallel=FALSE) {

	# Variable für Output
	out=NULL
	
	# soll parallel gerechnet werden?
	if( parallel )
	#if( "rparallel" %in% names( getLoadedDLLs()) )  # wenn package "rparallel" geladen, dann parallel rechnen
 	{
 		# Berechnet die Schlaufe im else{} parallel. mit 'resultOp' angeben,
	 	# was mit Resultat gemacht werden soll (z.B. min(), max(), '+' ...)
      		runParallel( resultVar="out", resultOp="rbind", nWorkers=2)
	}
	# im else{} muss Schlaufenkonstrukt stehen, das parallelisiert werden soll
	else
	{
		for (k in 1:(length(x)-n)) {
			# irgendeine Berechnung (aber keine iterativen Berechnungen, wie: a[n]=a[n-1]+1)
			temp=(x[k]:x[k+n])^2
			# Resultat zusammenfügen
			out=rbind(out, temp) # <- muss sich mit der 'resultOp' decken
			}
	}
	return(out)
}

#---
# Zeitvergleich
#---

# mit einem Prozessor
system.time({
res=test(2:50000, n=5, parallel=F)
})
#       User      System verstrichen
#      88.94        1.48       90.58

# mit zwei Prozessoren
system.time({
res=test(2:50000, n=5, parallel=T)
})
#       User      System verstrichen
#      30.27        0.06       45.11

#--- bei kurzen Schlaufen lohnt es sich nicht:

# mit einem Prozessor
system.time({
res=test(2:50, n=5, parallel=F)
})
#       User      System verstrichen
#          0           0           0

# mit zwei Prozessoren
system.time({
res=test(2:50, n=5, parallel=T)
})
#       User      System verstrichen
#       2.93        0.02        3.61