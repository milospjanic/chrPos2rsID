# chrPos2rsID

chrPos2rsID is a script to convert a list of genomics positions in a format: chrno_position_allele1_allele2 to SNP rsIDs. Script will append rsIDs as a column to an existing file. chrPos2rsID is useful for quick conversion of to SNP rsIDs for various downstream analysis and lookups.

**Usage**

This script will check if the working folder is present and if not it will create ~/chrPos2rsID. Next, script will go into ~/chrPos2rsID and check if dbSNP bed file for human genome hg19 is present or not, version 147 (the latest one present in the mySQL database currently), and case it is not present it will download it using mySQL from snp147Common table of hg19 dataset on genome-mysql.cse.ucsc.edu.

Your input file should be formatted as:

<pre>
MarkerName	Allele1	Allele2	Freq1	Effect	StdErr	P-value	Direction	
6_34845648_C_T	t	c	0.8545	0.1959	0.0484	5.11E-05	++	
6_34883363_A_G	a	g	0.146	-0.1927	0.0484	6.96E-05	--	
6_34908015_C_T	t	c	0.144	-0.1931	0.0489	7.78E-05	--	
6_34906168_C_T	t	c	0.856	0.1931	0.0489	7.78E-05	++	
6_34851134_C_T	t	c	0.8545	0.1908	0.0484	8.09E-05	++	
6_34846832_A_G	a	g	0.1456	-0.1904	0.0484	8.32E-05	--	
6_34847229_C_T	t	c	0.8547	0.1907	0.0485	8.38E-05	++	
6_34861103_C_G	c	g	0.8548	0.19	0.0484	8.77E-05	++	
6_34861799_A_G	a	g	0.1452	-0.19	0.0484	8.78E-05	--	
</pre>

Next an akw code will parse your file to free up chr and position from the first column, append chr to newly formed first column, remove alleles, and perform comparison of your file and dbSNP MySQL data using 3 different hash tables in awk. Script will output a file of your input snps with rsID appended to it, separated by tab and save it as $1.rsID, $1 being first parameter provided to the script that should be the file name containing SNPs.

Output file will be placed in ~/chrPos2rsID

MySQL download will produce a file snp147Common.bed, with 14,815,821 SNPs:
<pre>
head snp147Common.bed
chr1	10177	10177	rs367896724
chr1	10352	10352	rs555500075
chr1	11007	11008	rs575272151
chr1	11011	11012	rs544419019
chr1	13109	13110	rs540538026
chr1	13115	13116	rs62635286
chr1	13117	13118	rs62028691
chr1	13272	13273	rs531730856
chr1	13417	13417	rs777038595
chr1	14463	14464	rs546169444

mpjanic@zoran:~/rsID2Bed$ wc -l snp147Common.bed 
14815821 snp147Common.bed
</pre>

**Running**

To run the script type:
<pre>
chmod 775 chrPos2rsID.sh 
./chrPos2rsID.sh path/to/file
</pre>

**Prerequisites**

MySQL

**Example**

<pre> 
head SNP.file
MarkerName	Allele1	Allele2	Freq1	Effect	StdErr	P-value	Direction	
6_34845648_C_T	t	c	0.8545	0.1959	0.0484	5.11E-05	++	
6_34883363_A_G	a	g	0.146	-0.1927	0.0484	6.96E-05	--	
6_34908015_C_T	t	c	0.144	-0.1931	0.0489	7.78E-05	--	
6_34906168_C_T	t	c	0.856	0.1931	0.0489	7.78E-05	++	
6_34851134_C_T	t	c	0.8545	0.1908	0.0484	8.09E-05	++	
6_34846832_A_G	a	g	0.1456	-0.1904	0.0484	8.32E-05	--	
6_34847229_C_T	t	c	0.8547	0.1907	0.0485	8.38E-05	++	
6_34861103_C_G	c	g	0.8548	0.19	0.0484	8.77E-05	++	
6_34861799_A_G	a	g	0.1452	-0.19	0.0484	8.78E-05	--	

./chrPos2rsID.sh SNP.file

head SNP.file.rsID
chr	position	Allele1	Allele2	Freq1	Effect	StdErr	P-value	Direction	
rs2985	chr6	34845648	t	c	0.8545	0.1959	0.0484	5.11E-05	++	
rs2092428	chr6	34883363	a	g	0.146	-0.1927	0.0484	6.96E-05	--	
rs847847	chr6	34908015	t	c	0.144	-0.1931	0.0489	7.78E-05	--	
rs847848	chr6	34906168	t	c	0.856	0.1931	0.0489	7.78E-05	++	
rs2273006	chr6	34851134	t	c	0.8545	0.1908	0.0484	8.09E-05	++	
rs4646944	chr6	34846832	a	g	0.1456	-0.1904	0.0484	8.32E-05	--	
rs4646940	chr6	34847229	t	c	0.8547	0.1907	0.0485	8.38E-05	++	
rs9394252	chr6	34861103	c	g	0.8548	0.19	0.0484	8.77E-05	++	
rs13219624	chr6	34861799	a	g	0.1452	-0.19	0.0484	8.78E-05	--	
</pre>
