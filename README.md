# ANGSD_SFS_pipeline
A small script used for comparison of different Genotype Likelihood models.

Version of ANGSD used: 0.934 (htslib: 1.12)

This pipeline was created to demonstrate the differences in the calculation of SFS depending on the use of different GL models (primarily those included in ANGSD), whose behavior changes with different coverage of genomic data. Thus, when using low coverage data(<5X), it can be seen that multisample calling results in underestimation of the number of rare variants. 

### Preparation

Firstly, create directories where you will be working:
```
mkdir SFS
cd SFS
mkdir bams
```

Intsall SAMtools: http://www.htslib.org/download/
Install ANGSD: http://www.popgen.dk/angsd/index.php/ANGSD
Check http://www.popgen.dk/angsd/index.php/Quick_Start for quick start and data examples.

Also you will need an Rscript to run sfs_barplot.R
You can install it with:
```
sudo apt install r-base
```

Input data are BAM files that are aligned to the reference, indexed and sorted. 

You will also need a reference genome and ancestral states. The latter (for hg19) can be found on: http://popgen.dk/software/download/angsd/hg19ancNoChr.fa.gz. Both of the files are needed to be indexed as well.

The ancestral state needs to be supplied for the full SFS, but you can use the -fold 1 (used in old versions of ANGSD) to estimate the folded SFS and then use the reference as ancestral.

```
#For indexing fasta file run:
samtools faidx name.fa

#For indexing BAM file run:
samtools index name.bam
```

Insert path for the directory with bams into BAM_PATH. 
Insert path to the reference and ancestral states into ANC and REF.

In order to run script, you'll have to know mean coverage of your bam files.
It can be obtained with samtools:
```
#This will create a nice histogram of BAM coverage
samtools coverage -A -w 32 input.bam
```
After that, insert mean coverage in MEAN_COV and desired lower coverage values in COV_ARRAY.

This version of script supports only GL models implementede in ANGSD (GL 1 (SAMtools) & GL 2 (GATK))

### Downsampling

The coverage of data is artificially lowered (downsampled) with the help of SAMtools, which randomly tosses out some of the reads, leaving a subset of them, while always keeping the paired reads. 

```
samtools view -bs 42.$FRAC $BAM > $COV.$BAM;
```

In this pipeline the seed of the random value generator is 42.
Insert the coverage value (which is used for file names) in COV.
Insert the fraction of original BAM-file which will not be tossed out in FRAC.
So, samtools view -bs 42.06 input.bam > subsampled.bam will subsample 6 percent of mapped reads with 42 as the seed for the random number generator.

### Site Frequency Spectrum

Description of SFS Estimation: http://www.popgen.dk/angsd/index.php/SFS_Estimation

First command generates site allele frequency likelihood(.saf) file.
Second command estimates SFS by optimizing .saf file.
Feel free to adjust filtering or exclude it at all.
Both files are generated in Results directory.

### Visualization of SFS in R

The SFS is obtained by counting the number of derived SNPs.
Final histogramm shows the distribution of the allele frequencies of SNPs.
After generating .sfs file, an R script will be launched to create barplots of SFS files.
