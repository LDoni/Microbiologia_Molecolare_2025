
####################################
#   INTRODUZIONE A R              #
####################################

# "#" crea un commento e non viene eseguito

###############################
## DOVE SIAMO NEL COMPUTER? ##
###############################

getwd()     # mostra la working directory attuale
?getwd()    # help della funzione

# andare alla cartella "IntroductionR"
setwd("IntroductionR/")
getwd()

# cosa contiene la cartella?
list.files()


###########################
#   CALCOLI DI BASE       #
###########################

4 + 4
4 / 2
4 * 4
2 ^ 4   # elevamento a potenza
5/0

# tipi di dati di base
42        # numerico (numeric)
"ciao"    # testo (character) --> sempre tra virgolette sennò cerca una variabile
TRUE      # logico (logical)


##########################
#   OPERATORI LOGICI     #
##########################

2 + 2 == 5   # uguale?
-1.9 > -2
4 > 7
!TRUE         # NOT


####################
#   VARIABILI      #
####################

# assegnazione con <- o =
x = 7
x <- 7

x
x + 3
2 ^ x
x * x

# tipo di dato

class(x)


w <- "europa"
class(w)

w <- europa #perché?

 w * 2 


######################
##  SEQUENCES E rep ##
######################

1:10
seq(1, 20, by = 2)
rep(5, times = 3)


###############
## VETTORI   ##
###############

# C() = concatenazione
y <- c(5, 6, 7)
y
y*5
y*w

logical_vec <- c(TRUE, FALSE, TRUE)
char_vec <- c("a", "b", "c")


#######################
##  DATA FRAME       ##
#######################

# creiamo un secondo vettore
z <- c(8, 9, 10)

our_table <- data.frame(y, z)
our_table
class(our_table)

# struttura dell’oggetto: molto utile!
str(our_table)


###############################
#   INDICIZZAZIONE (INDEXING) #
###############################

y       # il vettore intero
y[1]    # primo elemento
y[2]
y[3]

y[-1]   # tutto tranne il primo

# multipli
y[c(1,3)]

# condizionale
y[y >= 6]
y[!y >= 6]   # ! = NOT


### subset per tabelle
our_table
our_table[2, 2]

our_table[, 2]   # tutte le righe, solo colonna 2
our_table[3, ]   # solo riga 3

# nomi colonne
colnames(our_table)

# con il nome della colonna
our_table$z
our_table[c(2,3), "z"]


###############################
#   FUNZIONI UTILI DI BASE    #
###############################

mean(y)
sum(y)
length(y)
min(y)
max(y)


##########################################
#   LEGGERE E SCRIVERE FILE SU DISCO     #
##########################################

?read.table

# puoi anche usare file.choose(), molto utile per principianti
# gene_annotations_tab <- read.table(file.choose(), sep="\t", header=TRUE)

gene_annotations_tab <- read.table("gene_annotations500.txt",
                                   sep = "\t",
                                   header = TRUE)

head(gene_annotations_tab)
colnames(gene_annotations_tab)
dim(gene_annotations_tab)

# struttura
str(gene_annotations_tab)


##########################
#   LAVORARE CON GLI NA  #
##########################

head(gene_annotations_tab$KO_ID)
is.na(head(gene_annotations_tab$KO_ID))

# contare quanti NA
sum(is.na(gene_annotations_tab$KO_ID))

# rimuovere righe con NA in KO_ID
KEGG_only_tab <- gene_annotations_tab[!is.na(gene_annotations_tab$KO_ID), ]

dim(gene_annotations_tab)
dim(KEGG_only_tab)


#########################
#   SALVARE UN FILE     #
#########################

?write.table

write.table(KEGG_only_tab,
            "KEGG_annotated.csv",
            sep = ",",
            row.names = FALSE,
            quote = FALSE)

list.files()   # verifica che sia stato creato


###############################
#   GRAFICI BASE (PLOT)       #
###############################

# Scatterplot con personalizzazioni base
plot(
  y, z,
  main = "Relazione tra y e z",
  xlab = "Valori di y",
  ylab = "Valori di z",
  pch = 19,        # punto pieno
  col = "blue",    # colore
  cex = 1.5        # grandezza dei punti
)

# Istogramma più carino
hist(y,
  main = "Distribuzione dei valori di y",
  xlab = "Valore",
  col = "lightgreen",
  border = "white",
  breaks = 5
)

################################
#   LO STESSO CON ggplot2      #
################################

# installiamo il pacchetto la prima volta


#install.packages("ggplot2")

library(ggplot2)

# trasformiamo y e z in un dataframe
df <- data.frame(y = y, z = z)

# scatterplot
ggplot(df, aes(x = y, y = z)) +
  geom_point(size = 3, color = "red") +
  labs(
    title = "Relazione tra y e z (ggplot2)",
    x = "Valori di y",
    y = "Valori di z"
  ) +
  theme_minimal()

# istogramma
ggplot(df, aes(x = y)) +
  geom_histogram(
    bins = 5,
    fill = "purple",
    color = "white"
  ) +
  labs(
    title = "Distribuzione dei valori di y (ggplot2)",
    x = "Valore di y"
  ) +
  theme_minimal()


