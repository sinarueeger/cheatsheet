## -------------------------------------------------------------------
## KTI Enertec
## Michel Philipp, IDP
##
## Untersuchung über Einfluss des Tiefschliffs auf die
## Empfindlichkeit (SNR = Signal to Noise Ratio).
##
## SNR = abs(huberM[pos.Last] - huberM[neg.Last])
##             / mean(mad[pos.Last], mad[neg.Last])
##
## SNR wird berechnet pro [Stange, Messstelle, Messschritt].
## Dies entspricht 9 (Stangen) * 3 (Messschritte) = 27
## Beobachtungen an Messstelle A1 (Juli 2010).
## -------------------------------------------------------------------

library(lattice)
library(reshape)

## Workspace Aufräumen
rm(list=ls())

## Funktionen für Lattice-Grafiken
lattice.dotplot1 <- function(x,y) {
    panel.abline(h=10, lty=2, col=2)
    panel.abline(h=5, lty=2, col=2)
    panel.abline(h=0, lty=2, col=1)
    panel.abline(v=1:3, lty=2, col="lightgray")
    panel.xyplot(x,y, pch=19)
}

lattice.dotplot2 <- function(x,y) {
    panel.abline(h=10, lty=2, col=2)
    panel.abline(h=5, lty=2, col=2)
    panel.abline(h=0, lty=2, col=1)
    panel.abline(v=1:3, lty=2, col="lightgray")
    panel.xyplot(x,y, type="n")
    lpoints(jitter(as.numeric(x), 0.5),y, pch=19, col=rainbow(length(y)/nlevels(x)))
}

lattice.dotplot3 <- function(x,y) {
    panel.abline(h=10, lty=2, col=2)
    panel.abline(h=5, lty=2, col=2)
    panel.abline(h=0, lty=2, col=1)
    panel.abline(v=1:4, lty=2, col="lightgray")
    panel.xyplot(x,y, type="n")
    lpoints(jitter(as.numeric(x), 0.5),y, pch=19)
}

lattice.bwplot <- function(x,y) {
    panel.abline(h=10, lty=2, col=2)
    panel.abline(h=5, lty=2, col=2)
    panel.abline(h=0, lty=2, col=1)
    panel.abline(v=1:3, lty=1, col="lightgray")
    panel.bwplot(x, y, horizontal=FALSE)
}

## Vorbereitete Daten
load("..\\dat\\data.dat")

## Wichtigste Festures gemäss randomForest aus MAchbarkeitsstudie
imp.features <- c("R_Mmax_2","R_Mmax_1","R_DH25m_2", "R_DH50m_2","R_A5","R_P7","R_Phr_1")

## Einschränkung auf Messstelle A1 und Messschritte D13, D21, D23
ok    <- data.aggr.mu$Messstelle %in% c("A1") &
         data.aggr.mu$Messschritt %in% c("D13","D21","D23") &
         data.aggr.mu$Last %in% c(-50, 300)
X.mu  <- data.aggr.mu[ok,]
X.mad <- data.aggr.mad[ok,]

## Welche Spalten in X.mu sind Features?
col.features <- grep("R_", colnames(X.mu), fixed=TRUE)

## Suche Zeilen mit positiver / negativer Last
rows.pos <- which(X.mu$Last > 0)
rows.neg <- which(X.mu$Last < 0)

## Wichtig!!! Prüfe, ob die Zeilen für pos und neg Lasten
## in gleicher Reihenfolge sind.
stopifnot(all((X.mu[rows.pos,1:5] == X.mu[rows.neg,1:5])))

## Das Feature "R_Vmag" eignet sich nicht für die Berechnung
## des STN, weil keine Streuung vorhanden ist. Wird daher entfernt.
col.features <- col.features[-1]

## Berechne Differenzen, den pooled mad und SNR
X.mu.diff    <- X.mu[rows.pos,col.features] - X.mu[rows.neg,col.features]
X.mad.pooled <- (X.mad[rows.pos,col.features] + X.mad[rows.neg,col.features])/2
X.snr        <- abs(X.mu.diff)/X.mad.pooled
X            <- cbind(X.mu[1:27,1:5], X.snr)

## data.frame X in long-Format umrechnen für lattice-Grafiken
col.features <- grep("R_", colnames(X), fixed=TRUE)
X.long <- melt(X, measure.vars=col.features)

## y-Label für SNR
ylab.SNR <- "SNR = abs(huberM[pos.Last] - huberM[neg.Last]) / mean(mad[pos.Last], mad[neg.Last])"
ylab.SNR <- "Signal to Noise Ratio (SNR)"

strip.names <- sort(unique(paste(X$StabID, X$Sorte, X$Durchmesser, sep=" / ")))

## Plot: SNR ~ Messschritt | Stab (getrennt nach Features)
pdf("VV__SNR_vs_Messschritt_pro_Stab_und_Feature.pdf")
for (col in col.features)
{
    ylim <- c(0,max(X[,col])) + c(-1,1) * 0.1 * max(X[,col])
    x1 <- dotplot(X[,col] ~ X$Messschritt | X$StabID, panel=lattice.dotplot1, ylim=ylim,
                  strip = strip.custom(factor.levels = strip.names),
                  ylab=ylab.SNR, main=paste("SNR vs. Messchritt pro Stab für Feature\n", colnames(X)[col],sep=""),
                  sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
    plot(x1)
}
dev.off()

## Plot: SNR ~ Messschritt | Stab
pdf("VV__SNR_vs_Messschritt_pro_Stab.pdf")
bwplot(value ~ Messschritt | StabID, data=X.long, panel=lattice.bwplot,
       strip = strip.custom(factor.levels = strip.names),
       ylab=ylab.SNR, main="SNR vs. Messchritt pro Stab",
       sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
dev.off()

## Plot: SNR ~ Messschritt | Feature
pdf("VV__SNR_vs_Messschritt_pro_Feature.pdf", height=12, width=12)
dotplot(value ~ Messschritt | variable, data=X.long, panel=lattice.dotplot2,
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Feature",
        sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen",
        key=simpleKey(as.character(unique(X.long$StabID)), columns=5, col=rainbow(9), points=FALSE))
dev.off()

pdf("SNR_vs_Messschritt_pro_Feature_limited.pdf", height=12, width=12)
ylim <- c(0,20) + c(-1,1) * 0.1 * 20
dotplot(value ~ Messschritt | variable, data=X.long, panel=lattice.dotplot2, ylim=ylim,
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Feature",
        sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen",
        key=simpleKey(as.character(unique(X.long$StabID)), columns=5, col=rainbow(9), points=FALSE))
dev.off()

## Folgende Plots sind nur für die wichtigsten Features.
ok <- X.long$variable %in% imp.features

## Plot: SNR ~ Messschritt | Stab (getrennt nach Features)
pdf("VV__SNR_vs_Messschritt_pro_Stab_und_Feature_VIP.pdf")
for (col in imp.features)
{
    ylim <- c(0,max(X[,col])) + c(-1,1) * 0.1 * max(X[,col])
    x1 <- dotplot(X[,col] ~ X$Messschritt | X$StabID, panel=lattice.dotplot1, ylim=ylim,
                  strip = strip.custom(factor.levels = strip.names),
                  ylab=ylab.SNR, main=paste("SNR vs. Messchritt pro Stab für Feature\n", col,sep=""),
                  sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
    plot(x1)
}
dev.off()

## Plot: SNR ~ Messschritt | Stab
pdf("VV__SNR_vs_Messschritt_pro_Stab_VIP.pdf")
dotplot(value ~ Messschritt | StabID, data=X.long[ok,], panel=lattice.dotplot2,
        strip = strip.custom(factor.levels = strip.names),
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Stab",
        sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen",
        key=simpleKey(imp.features, columns=5, col=rainbow(7), points=FALSE))
dev.off()

## Plot: SNR ~ Messschritt | Feature
pdf("VV__SNR_vs_Messschritt_pro_Feature_VIP.pdf")
dotplot(value ~ Messschritt | variable, data=X.long[ok,], panel=lattice.dotplot2,
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Feature",
        sub="D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen",
        key=simpleKey(imp.features, columns=5, col=rainbow(7), points=FALSE))
dev.off()

## -------------------------------------------------------------------
## Resultate aus Machbarkeitsstudie
## -------------------------------------------------------------------

## Zeilen mit positiver und negativer Last aus df auswählen
rows.pos <- data.MS.aggr.mu$Last %in% 290:310
rows.neg <- data.MS.aggr.mu$Last %in% -60:-40

## Mittle über mehrfache Zeilen in data.frames mit huberM- und MAD-Werten
X.mu.pos  <- apply(data.MS.aggr.mu[rows.pos,-c(1:3)], 2,
                   function(x) tapply(x, data.MS.aggr.mu[rows.pos,1], mean))
X.mu.neg  <- apply(data.MS.aggr.mu[rows.neg,-c(1:3)], 2,
                   function(x) tapply(x, data.MS.aggr.mu[rows.neg,1], mean))
X.mad.pos <- apply(data.MS.aggr.mad[rows.pos,-c(1:3)], 2,
                   function(x) tapply(x, data.MS.aggr.mad[rows.pos,1], mean))
X.mad.neg <- apply(data.MS.aggr.mad[rows.neg,-c(1:3)], 2,
                   function(x) tapply(x, data.MS.aggr.mad[rows.neg,1], mean))

## Erstes Feature nicht brauchbar
X.mu.pos  <- X.mu.pos[,-1]
X.mu.neg  <- X.mu.neg[,-1]
X.mad.pos <- X.mad.pos[,-1]
X.mad.neg <- X.mad.neg[,-1]

## Berechne Signal to Noise Ratio (SNR)
X.mu.diff    <- X.mu.pos - X.mu.neg
X.mad.pooled <- (X.mad.pos + X.mad.neg) / 2
X.snr        <- abs(X.mu.diff)/X.mad.pooled
X.MS         <- data.frame(StabID = levels(data.MS.aggr.mu$pruef.dat), X.snr)

## Entferne ".mu" aus Spaltennamen
colnames(X.MS)[-1] <- substring(colnames(X.MS)[-1], 1, sapply(colnames(X.MS)[-1], nchar)-3)

## Wähle Featurespalten aus und forme Dataframe für Latticegrafiken um
col.features <- grep("R_", colnames(X.MS), fixed=TRUE)
X.MS.long <- melt(X.MS, id.vars=1, measure.vars=col.features)

## NA-Zeilen entfernen und Faktoren erneuern
X.MS.long <- X.MS.long[!is.na(X.MS.long$value),]
X.MS.long$StabID   <- factor(X.MS.long$StabID)
X.MS.long$variable <- factor(X.MS.long$variable)

## Plot: SNR ~ Feature aus Machbarkeitsstudie
pdf("MS__SNR_pro_Feature.pdf", height=12, width=12)
par(mar=c(5.1, 6.1, 4.1, 2.1))
boxplot(value ~ variable, data=X.MS.long, horizontal=TRUE, las=2, cex.axis=0.7,
        main="SNR pro Feature in Machbarkeitsstudie", xlab=ylab.SNR)
abline(v=10, lty=2, col=2)
abline(v=5, lty=2, col=2)
abline(v=0, lty=2, col=1)
dev.off()

## Plot: SNR ~ StabID aus Machbarkeitsstudie
pdf("MS__SNR_pro_Stab.pdf", height=12, width=12)
boxplot(value ~ StabID, data=X.MS.long, horizontal=TRUE, las=2,
        main="SNR pro Stab in Machbarkeitsstudie", xlab=ylab.SNR)
abline(v=10, lty=2, col=2)
abline(v=5, lty=2, col=2)
abline(v=0, lty=2, col=1)
dev.off()

ok <- X.MS.long$variable %in% imp.features
XX.MS.long <- X.MS.long[ok,]
XX.MS.long <- XX.MS.long[!is.na(XX.MS.long$value),]
XX.MS.long$StabID <- factor(XX.MS.long$StabID)
XX.MS.long$variable <- factor(XX.MS.long$variable)

## Plot: SNR ~ Feature aus Machbarkeitsstudie (nur wichtigste Features)
pdf("MS__SNR_pro_Feature_VIP.pdf", height=12, width=12)
par(mar=c(5.1, 6.1, 4.1, 2.1))
boxplot(value ~ variable, data=XX.MS.long, horizontal=TRUE, las=2,
        main="SNR pro Feature in Machbarkeitsstudie", xlab=ylab.SNR)
abline(v=10, lty=2, col=2)
abline(v=5, lty=2, col=2)
abline(v=0, lty=2, col=1)
dev.off()

## Plot: SNR ~ StabID aus Machbarkeitsstudie (nur wichtigste Features)
pdf("MS__SNR_pro_Stab_VIP.pdf", height=12, width=12)
boxplot(value ~ StabID, data=XX.MS.long, horizontal=TRUE, las=2,
        main="SNR pro Stab in Machbarkeitsstudie", xlab=ylab.SNR)
abline(v=10, lty=2, col=2)
abline(v=5, lty=2, col=2)
abline(v=0, lty=2, col=1)
dev.off()

## -------------------------------------------------------------------
## Vergleiche Vorversuch mit Machbarkeitsstudie
## -------------------------------------------------------------------

## Bilde Data-Frame mit Daten aus Vorversuch und Machbarkeitsstudie
X.all.long <- rbind(data.frame(StabID = X.MS.long$StabID,
                               Messschritt = "MS",
                               variable = X.MS.long$variable,
                               value = X.MS.long$value),
                    data.frame(StabID = X.long$StabID,
                               Messschritt = X.long$Messschritt,
                               variable = X.long$variable,
                               value = X.long$value))

## Faktoren neu setzen
X.all.long$StabID <- factor(X.all.long$StabID)
X.all.long$Messschritt <- factor(X.all.long$Messschritt)

## Plot: SNR ~ Messschritt | Feature aus MS und VV
pdf("VV_MS__SNR_vs_Messschritt_pro_Feature.pdf", height=12, width=12)
dotplot(value ~ Messschritt | variable, data=X.all.long, panel=lattice.dotplot3,
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Feature",
        sub="MS = Machbarkeitsstudie | D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
dev.off()

## Plot: SNR ~ Messschritt | Feature aus MS und VV (mit limitierter y-Achse)
pdf("VV_MS__SNR_vs_Messschritt_pro_Feature_limited.pdf", height=12, width=12)
ylim <- c(0,20) + c(-1,1) * 0.1 * 20
dotplot(value ~ Messschritt | variable, data=X.all.long, panel=lattice.dotplot3, ylim=ylim,
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Feature",
        sub="MS = Machbarkeitsstudie | D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
dev.off()

## Plot: SNR ~ Messschritt aus MS und VV
pdf("VV_MS__SNR_vs_Messschritt.pdf")
boxplot(value ~ Messschritt, data=X.all.long,
        main="SNR vs. Messschritt im Vergleich mit MS", ylab=ylab.SNR)
abline(h=10, lty=2, col=2)
abline(h=5, lty=2, col=2)
abline(h=0, lty=2, col=1)
dev.off()

ok <- X.all.long$variable %in% imp.features
XX.all.long <- X.all.long[ok,]
XX.all.long$StabID <- factor(XX.all.long$StabID)
XX.all.long$Messschritt <- factor(XX.all.long$Messschritt)

## Plot: SNR ~ Messschritt | Feature aus MS und VV (nur wichtigste Feature)
pdf("VV_MS__SNR_vs_Messschritt_pro_Feature_VIP.pdf")
dotplot(value ~ Messschritt | variable, data=XX.all.long, panel=lattice.dotplot3,
        ylab=ylab.SNR, main="SNR vs. Messchritt pro Feature",
        sub="MS = Machbarkeitsstudie | D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
dev.off()

## Plot: SNR ~ Messschritt aus MS und VV (nur wichtigste Feature)
pdf("VV_MS__SNR_vs_Messschritt_VIP.pdf")
boxplot(value ~ Messschritt, data=XX.all.long,
        main="SNR vs. Messschritt im Vergleich mit MS", ylab=ylab.SNR,
        sub="MS = Machbarkeitsstudie | D13 = Schleifen | D21 = Fräsen | D23 = Fräsen und Schleifen")
abline(h=10, lty=2, col=2)
abline(h=5, lty=2, col=2)
abline(h=0, lty=2, col=1)
dev.off()
