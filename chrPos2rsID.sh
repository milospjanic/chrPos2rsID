#!/bin/bash

FILE=~/rsID2Bed/snp147Common.bed
DIR=~/rsID2Bed
SNPS=$(pwd)/$1
echo Proccesing file:
echo $SNPS 

#check if working folder exist, if not, create

if [ ! -d $DIR ]
then
mkdir ~/rsID2Bed
fi

cd ~/rsID2Bed

#check if dbsnp file exists, if not, download from snp147Common table using mysql

if [ ! -f $FILE ]
then
mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -N -D hg19 -e 'SELECT chrom, chromStart, chromEnd, name FROM snp147Common' > snp147Common.bed
fi

tabsep $SNPS
sed 's/^/chr/g' SFJK_regions.IL_16.20161129SIG.txt | sed 's/_/\t/' | sed 's/_.//' | sed 's/_.//' > $SNPS.mod
sed 's/^MarkerName/chr\tposition\t/g' <(head -n1 $SNPS) > $SNPS.head
cat $SNPS.head <(tail -n+2 $SNPS.mod) > $SNPS.mod2
mv $SNPS.mod2 $SNPS.mod
tabsep $SNPS.mod
tail -n+2 $SNPS.mod > $SNPS.mod2
head -n1 $SNPS.mod > $SNPS.head


#find positions of snps from the input list by comparing to snpdb
awk 'NR==FNR {h1[$1] = 1; h2[$3]=1; h3[$1$3]=$4; next} {if(h2[$2]==1 && h1[$1]==1) print h3[$1$2]"\t"$0}' snp147Common.bed $SNPS.mod2 > $SNPS.rsID.nohead
sed '1s/^/rsID/' $SNPS.head
cat $SNPS.head $SNPS.rsID.nohead > $SNPS.rsID
