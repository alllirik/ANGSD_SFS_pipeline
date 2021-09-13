# ANGSD_SFS_pipeline
A small script used for comparison of different Genotype Likelihood models.

Version of ANGSD used: 0.921 (htslib: 1.9)

This pipeline was created to demonstrate the differences in the calculation of SFS depending on the use of different GL models (primarily those included in ANGSD), whose behavior changes with different coverage of genomic data. Thus, when using low coverage data(<5X), it can be seen that multisample calling results in underestimation of the number of rare variants. 

### Preparation

Firstly, create directories where you will be working:
```
mkdir SFS
cd SFS
mkdir bams
mkdir Results
```

Intsall SAMtools: http://www.htslib.org/download/
Install ANGSD: http://www.popgen.dk/angsd/index.php/ANGSD
Check http://www.popgen.dk/angsd/index.php/Quick_Start for quick start and data examples.

Secondly, set paths for all software if needed:
```
ANGSD=~/Software/angsd
SAMTOOLS=~/Software/samtools-1.12/samtools
```

Input data are BAM files that are aligned to the reference, indexed and sorted. 

You will also need a reference genome and ancestral states. The latter (for hg19) can be found on: http://popgen.dk/software/download/angsd/hg19ancNoChr.fa.gz. Both of the files are needed to be indexed as well.

The ancestral state needs to be supplied for the full SFS, but you can use the -fold 1 to estimate the folded SFS and then use the reference as ancestral.

```
#For indexing fasta file run:
samtools faidx name.fa

#For indexing BAM file run:
samtools index name.bam
```

Insert path for the directory with bams into BAM_PATH. 
Insert path to the reference and ancestral states into ANC and REF.

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

### Visualisation of SFS in R

The SFS is obtained by counting the number of derived SNPs.
Final histogramm shows the distribution of the allele frequencies of SNPs.
After generating .sfs file, you can compare different GL models in one barplot by using this simple R code that can be found in sfs_barplot.R:

```
nnorm <- function(x) x/sum(x)
res <- rbind(
  GL1=scan("path/to/file/filename.GL1.2X.sfs")[-1],
  GL2=scan("path/to/file/filename.GL2.2X.sfs")[-1],
  GL3=scan("path/to/file/filename.GL3.2X.sfs")[-1]
  )
  
  #density instead of expected counts
  res <- t(apply(res,1,nnorm))

#plot the none ancestral sites
barplot(res,beside=T,main="Folded SFS 2X", names=1:4, col=c("lightblue","blue","darkblue"))
legend("topright", 
       fill = c("lightblue","blue","darkblue"),
       legend = c("SAMtools", "GATK", "SYK"), 
       cex = 0.35)

```
