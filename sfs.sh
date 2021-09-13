ANGSD =
SAMtools =
ANC=Homo_sapiens_assembly38.fasta
REF=Homo_sapiens_assembly38.fasta
BAM_PATH =
COV=2X
FRAC=06

for BAM in BAM_PATH/*.bam
do
	$SAMtools view -bs 42.$FRAC "${BAM##*/}" > $COV."${BAM##*/}"
done

ls $COV* > $COV.filelist
$ANGSD/angsd -b $COV.filelist -anc $ANC -ref $REF -doCounts 1 -baq 1 -C 50 -minMapQ 30 -minQ 20 -minInd 2 -P 2 -GL 2 -doSaf 1 -fold 1 -out Results/$COV
$ANGSD/misc/realSFS -maxIter 100 -P 2 Results/$COV.saf.idx > Results/$COV.sfs

