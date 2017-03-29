#!/bin/bash

FILE=~/chrPos2rsID/snp147Common.bed
DIR=~/chrPos2rsID
SNPS=$(pwd)/$1
echo Proccesing file:
echo $SNPS 

#check if working folder exist, if not, create

if [ ! -d $DIR ]
then
mkdir ~/chrPos2rsID
fi

cd ~/chrPos2rsID

#check if dbsnp file exists, if not, download from snp147Common table using mysql

if [ ! -f $FILE ]
then
mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -N -D hg19 -e 'SELECT chrom, chromStart, chromEnd, name FROM snp147Common' > snp147Common.bed

fi

tabsep $SNPS
sed 's/^/chr/g' $SNPS | sed -e 's/_[ATCG]*/\t/' | sed -e 's/_[ATCG]*//' | sed 's/_.//' > $1.mod
sed 's/^MarkerName/chr\tposition\t/g' <(head -n1 $SNPS) > $1.head
cat $1.head <(tail -n+2 $1.mod) > $1.mod2
mv $1.mod2 $1.mod
tabsep $1.mod
tail -n+2 $1.mod > $1.mod2
head -n1 $1.mod > $1.head

#parse dbSNPs into insertions, SNPs and simple deletions, large deletions

if [ ! -f snp147Common.bed.insertions ]
then
awk '$2 == $3 {print $0}' snp147Common.bed > snp147Common.bed.insertions
fi

if [ ! -f snp147Common.bed.snp.plus.simple.deletions ]
then
awk '$3 == $2+1 {print $0}' snp147Common.bed > snp147Common.bed.snp.plus.simple.deletions
fi

if [ ! -f snp147Common.bed.large.deletions ]
then
awk '{if ($3 != $2+1 && $2 != $3) print $0}' snp147Common.bed > snp147Common.bed.large.deletions
fi

#find positions of snps from the input list by comparing to snpdb

awk 'NR==FNR {h1[$1] = 1; h2[$2]=1; h3[$1$2]=$4; next} {if(h2[$2]==1 && h1[$1]==1) print h3[$1$2]"\t"$0}' snp147Common.bed.insertions $1.mod2 > $1.rsID.nohead.insertions
awk 'NR==FNR {h1[$1] = 1; h2[$2]=1; h3[$1$2]=$4; next} {if(h2[$2]==1 && h1[$1]==1) print h3[$1$2]"\t"$0}' snp147Common.bed.snp.plus.simple.deletions $1.mod2 > $1.rsID.nohead.snp.plus.simple.deletions
awk 'NR==FNR {h1[$1] = 1; h2[$2]=1; h3[$1$2]=$4; next} {if(h2[$2]==1 && h1[$1]==1) print h3[$1$2]"\t"$0}' snp147Common.bed.large.deletions $1.mod2 > $1.rsID.nohead.large.deletions

#merge insertions, SNPs and simple deletions, large deletions

cat $1.rsID.nohead.insertions $1.rsID.nohead.snp.plus.simple.deletions $1.rsID.nohead.large.deletions > $1.rsID

sed -i '1s/^/rsID\t/' $1.head
cat $1.head $1.rsID.nohead > $1.rsID

rm $1.mod
rm $1.mod2
rm $1.head
rm $1.rsID.nohead
