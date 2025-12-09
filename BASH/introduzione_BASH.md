# Bash

## Paths, files and directories
Open linux or mac terminal
```
pwd #print working directory
cd #change directory (relative or absolute path)
cd .. # bring you back one directory up
cd ~ #cd home
ls #print list of elements in directory
ls –lh # print sizes in human readable format
man list # (or any command, gives the manual for that command)
history #dispay last commands
ls *.fasta #list all fasta files
mkdir newfoldername# make new directory
```
## Edit files
` nano nomefile #create new empty file`

Ctrl+S to save

Ctrl+X to exit

Ctrl+W to search
```
cp filename pathwheretocopy #copy file somewhere using absolute or relative path of where to copy
mv filename pathwheretocopy #mv file somewhere using absolute or relative path of where to copy
mv filename new_filename #rename file
less filename #see file
cat filename #similar to less
head filename #see first 10 rows of the file
tail filename #see last 10 rows of the file
head –n5 filename #(or tail –n 5) see only first 5 (or last) 5 rows
wc filename #outputs the number of words, lines, and characters
wc –l filename #outputs the number of lines
rm file #remove file
rm * #remove every file in that directory
cp –r foldername #copy folder
mv foldername pathwheretomove #move folder
rm –r foldername #remove folder
```
> tip: be VERY careful with rm, once you removed something there is no way to undo it; remember bash is case sensitive, the file, folder or scritp "Data" is different from "data".
---
## Merge and sort files
```
cat file1 file2 file3 … #merge multiple files in 1  
cat file1 file2 file3 > newfilename #redirect output to new file
sort file #sort the file, careful to computational sorting of file
sort –h file #human numeric sort
sort -k1,1 -k2,2n file #sort by first column adn then numerically by second column
sort -k1,1 -k2,2nr file #sort by first column adn then numerically by second column in reversed order
sort -k1,1V -k2,2n file #as before but human sorted
paste file1 file2 #merge lines of files
```
## Grep
```
grep "word" file #print all rows that contains "word"
grep -w "word" file #print all rows that contains exactly the pattern "word"
grep -V "word" file #inverted match, print all rows that not contain the patter "word"
grep -i "word" file #ignore case distinctions, grep both "word" and "WORD"
grep -c "word" file #count how many rows contain the patter "word"
grep –A10 "word" file # print rows containing pattern "word" and the 10 rows after
grep –B10 "word" file # print rows containing pattern "word" and the 10 rows before
grep –C10 "word" file # print rows containing pattern "word" and the 10 rows after and before
grep "Locus10[12]" file #print Locus101 and Locus102 
grep -E "(Locus101|Locus102)" file #print Locus101 and Locus102 
```
> special characters: 
> * ^ starting with ; grep "^>" file #print lines starting with ">"
> * $ ending with ; grep ">$" file #print lines ending with ">"

> Regular Expressions: a sequence of characters that specifies a pattern
---
## Awk
```
awk '{print $1}' file #print first column
awk '{print $0}' file #print all columns
awk '{print $NF}' file #print last column
awk '{print $4"\t"$1}' file #change orders of column and use tab as field separator in the output
awk -F";" '{print $3,$4}' file #fiels separator is ";"
awk '$1==$2 {print}' file #if first column = second column, print all columns
awk '$1 ~ /chr2|chr3/ { print $0 "\t" $3 - $2 }' file #if first column contain "chr2" or "chr3", print all columns, and a column with the difference between $3 and $2
awk '$1 ~ /chr1/ && $3 - $2 > 10 '{print}' file #if both the first column  contain "chr1" AND $3-$2>0 , print all columns
awk '{if ($1~">") print $0; else print length}' "fasta_file #print length instead of sequence in fasta file
```
---
## Sed
```
sed 's/Locus/Transcript/' file #for each line subtitute "Locus" with "Transcripts" at first occurrance
sed 's/Locus/Transcript/g' file #for each line subtitute "Locus" with "Transcripts" at first occurrance
sed -i 's/Locus/Transcript/g' file # overwrite input with the output
sed '/Locus/d' file #delete any row containing "Locus"
```

## Concatenate commands and programs
### Pipe | 
| connects the standard output of one process to the standard input of another

```
grep "word" file1 | sed 's/ /\t/g' | program1 > file2 #sed use as input the output of grep; when using pipe the "original" input has to be specified only in the first command
```
Se una riga contiene “word”, viene stampata. La pipe manda l’output di grep come input a sed. Questo comando sostituisce ogni spazio `" "` con un tab `\t` in tutta la riga (`g` = global)

## Variables
A variable in bash can be anything, a number, a character, a string of characters, a file, a folder.
Variables are in bash are indicated with $
```
var1="ciao"
echo $var1 #print ciao
echo "$var1" #print ciao
echo '$var1' #print var1
```
---
## For loop
```
for i in *.fasta; do echo $i; done
for i in *.fasta; do mv $i ${i::-5}”_filtered”; done
for i in *.fasta; do mv $i ${i:1:3}”.fasta” ; done
for i in *fastq; do sed ‘s/@/>/’ > $i”_editname” ; done
for i in *fasta; do grep –c”>” $i ; done > counts
for i in *fasta; do program1 $i > “output_”$i; done
for i in */ ; do cd $i; cp *.fasta ../; cd ..; done
```
## Bash script

Bash scripts are indicated with the .sh extention (python scripts with .py, perl scripts with .pl). 

Possiamo creare scripts con nano e inserire nella prima riga lo shebang `#!/bin/bash` che specifica all'interprete del sistema operativo quale programma utilizzare per eseguire lo script

Questo è lo script get_reads_from_list.sh
Possiamo scaricare nel terminale sia lo script che il file list_id che ci servirà per provarlo con wget:
```
wget https://github.com/LDoni/Microbiologia_Molecolare_2025/blob/main/BASH/get_reads_from_list.sh
wget https://github.com/LDoni/Microbiologia_Molecolare_2025/blob/main/BASH/list_ids
```
```
#!/bin/bash
# Retrieve FASTQ reads from a list of read IDs
# $1 = list of read IDs
# $2 = FASTQ file (.fastq.gz)

list="$1"
fastq="$2"

# loop through every ID in the list
while read id; do

    # print the header and the following 3 lines (the full FASTQ read)
    zcat "$fastq" | grep -A3 -w "^$id"

done < "$list" > "${list}.fastq"
```
Rendiamo lo script eseguibile con:
```
chmod +x get_reads_from_list.sh
```
Eseguiamo lo script e guardiamo il risultato:
```
bash get_reads_from_list.sh list_ids S1_10_L001_R1_001.fastq.gz
cat list_ids.fastq
```
## Conda
```
conda init bash # initialize conda
conda env list # see list of environments
conda activate "environment_name" # activate environment_name
conda list # see packages installed in that environment_name
conda deactivate # close environment 
```
Some usefull conda commands:

```
conda create --name <ENV_NAME> #Create a target conda environment
conda activate <ENV_NAME> #Activate a target environment
conda deactivate #Deactivate your current environment
conda info --envs #print a list of conda environments
conda list #print a lost of packages installed in your current environment
conda install -c <CONDA_CHANNEL> <PACKAGE_NAME> #install a conda package
```

A good practice is to create AND install necessary packages at the same moment :

```
conda create --name <ENV_NAME> -c <CONDA_CHANNEL> <PACKAGE_NAME>
```

Conda is a package manager based on python. Each conda environment can only have **ONE** specific version of python installed. Now the default version is the latest 3.X but some old software can be run only in python 2.7. To create a python 2.7 environment :

```
conda create --name <ENV_NAME> python=2.7
```
```
```
# Esercizi
Andare nella directory in cui sono presenti le raw reads, e listare i file presenti:
```
ls -l
```
- Visualizzare le prime 8 righe (prime 2 reads)
```
zcat S1_10_L001_R1_001.fastq.gz | head -n 8
```
- Sfogliare l’intero file
```
zcat S1_10_L001_R1_001.fastq.gz | less -S
```
- Contare le linee
```
zcat S1_10_L001_R1_001.fastq.gz | wc -l
```
- Numero di reads
```
echo $(( $(zcat S1_10_L001_R1_001.fastq.gz | wc -l) / 4 ))
```
Oppure possiamo usare grep -c
```
zcat test_S1_R1.fastq.gz | grep -c "^@"
```
`^@` matcha solo righe che iniziano con @.

Corrispondono?

- Lunghezza della prima read
```
zcat S1_10_L001_R1_001.fastq.gz | sed -n '2p' | awk '{print length}'
```
oppure usando il comando builtin di bash '${#variabile}'
```
seq=$(zcat S1_10_L001_R1_001.fastq.gz | sed -n '2p')
echo ${#seq}
```
- Stampare la lunghezza di ogni read:
```
zcat S1_10_L001_R1_001.fastq.gz | awk 'NR % 4 == 2 { print length($0) }'
```
Clicca Ctrl+c per fermare!

- Lunghezza media di tutte le reads
```
zcat S1_10_L001_R1_001.fastq.gz \
    | awk 'NR%4==2 { total+=length($0); n++ } END { print total/n }'
```
- Cercare e contare quante volte compare una sequenza specifica:
```
zcat S1_10_L001_R1_001.fastq.gz | grep -c "ACGTACG"
```
- Stampare tutte le righe che contengono una sequenza specifica:
```
zcat S1_10_L001_R1_001.fastq.gz | grep "ACGTACG"
```
- Rinominare i files
```
for f in *.fastq.gz; do
    sample=$(echo "$f" | cut -d'_' -f1)
    read=$(echo "$f" | grep -o "R[12]")
    new="test_${sample}_${read}.fastq.gz"
    mv "$f" "$new"
done
```
`echo "$f"`  -> stampa il nome del file ad esempio `S1_10_L001_R1_001.fastq.gz` 

La pipe passa l’output del comando precedente come input al comando successivo, cioè a cut. 

`cut`  taglia una stringa in campi. 
`-d'_'`  dice che il delimitatore è _ (underscore).
`-f1`  dice: "prendi il primo campo".

Applicato a S1_10_L001_R1_001.fastq.gz, diventa S1 (perchè i campi sono S1, 10, L001, R1 e 001.fastq.gz)
Questa stringa viene assegnata a sample con `sample=$(...)` 

Quindi per `S1_10_L001_R1_001.fastq.gz`  → sample="S1"

`read=$(echo "$f" | grep -o "R[12]")` 
per estrarre R1 o R2 dal nome del file.
`grep`  cerca un pattern nel testo, `-o`  stampa solo la parte che matcha il pattern, non l’intera riga.
`"R[12]"`  è una regular expression: 
R = lettera R. [12] = un carattere che può essere 1 oppure 2
per il file `R1`  → `read="R1"` 
`new="test_${sample}_${read}.fastq.gz"` Per costruire il nuovo nome del file.
`"test_"`  è una stringa fissa.

`${sample}`  viene sostituito con il contenuto della variabile sample (es. S1).

`${read}`  viene sostituito con R1 o R2.
se `sample="S1"`  e `read="R1"`  → `new="test_S1_R1.fastq.gz"` 
`mv`  è il comando per rinominare file.

`done`  segna la fine del ciclo for


- Aggiungere un prefisso a tutti gli header
```
zcat S1_R1.fastq.gz \
   | awk 'NR%4==1{print "@S1_" substr($0,2)} NR%4!=1{print}' \
   | gzip > S1_R1_renamed.fastq.gz
```
- Reindirizzare l’output in nuovi file
```
zcat S1_R1.fastq.gz | head -n 20 > subset_S1_R1.fastq
```
Con il `>`  creiamo o sovrascriviamo. Se invece vogliamo aggiungere una nuova riga ad un file di testo possiamo usare `>>` 

Ad esempio, creiamo un file di testo, e scriviamo all'interno una parola.
```
nano ciao.txt
```
Dopodichè, possiamo aggiungere una nuova riga al suo interno con:
```
echo "nuova frase da aggiungere al file di testo" >> ciao.txt
```
Poi visualizziamolo:
```
cat ciao.txt
```




### Good practices in bioinformatics :

  1. **Work in a robust and reproducible way**
  2. **Document each step**
  3. **Check everything between computational steps, errors can be silent**
  4. **Code should be readable and organized in a logical way**
  5. **Files, file names and folders organized in a logical way**
  6. **Humans doing rote activities tend to make many mistakes, have your computer do as much of this rote work as possible**
  7. **Internet is your best friend and mentor, google everything that you don't understand!**
  8. **If an error rise first of all try to solve the problem by yourself:** a) read the error message carefully; b) read again the help of the software; c) check for typos, they are everywhere; d) GOOGLE it!


### Some usefull online resources :

  1. **Stack Overflow**
  2. **BioStars**
  3. **Issue page of GitHub**.
  
---
