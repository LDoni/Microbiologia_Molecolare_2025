#!/bin/bash
# Retrieve FASTQ reads from a list of read IDs
# $1 = list of read IDs (es: @M06222:561:000000000-LJRM7:1:1101:9224:1233)
# $2 = FASTQ file (.fastq.gz)

list="$1"
fastq="$2"

# loop through every ID in the list
while read id; do

    # print the header and the following 3 lines (the full FASTQ read)
    zcat "$fastq" | grep -A3 -w "^$id"

done < "$list" > "${list}.fastq"
