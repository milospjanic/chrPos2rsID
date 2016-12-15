# chrPos2rsID



**Usage**

This script will check if the working folder is present and if not it will create ~/chrPos2rsID. Next, script will go into ~/chrPos2rsID and check if dbSNP bed file for human genome hg19 is present or not, version 147 (the latest one present in the mySQL database currently), and case it is not present it will download it using mySQL from snp147Common table of hg19 dataset on genome-mysql.cse.ucsc.edu.

Next an akw code will perform comparison of your file and dbSNP data from mysql and output a file for your input snps and save it as $1.bed, $1 being first parameter provided to the script that should be the file name containing SNPs.

Output file will be placed in ~/rsID2Bed
