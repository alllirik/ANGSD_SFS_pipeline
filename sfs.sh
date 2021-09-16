ANC=human_g1k_v37.fasta
REF=human_g1k_v37.fasta
BAM_PATH=bams
MEAN_COV=8
COV_ARRAY=(4 2)
MODEL_ARRAY=(1 2)

for COV in ${COV_ARRAY[*]}
do
	FRAC=($(bc <<< "scale=2;$COV/$MEAN_COV"))
	mkdir ${COV}X
	for BAM in $BAM_PATH/*.bam
	do
		samtools view -bs 42$FRAC $BAM > ${COV}X/${COV}X."${BAM##*/}"
	done
	ls ${COV}X/*.bam > ${COV}X.filelist
	for MODEL in ${MODEL_ARRAY[*]}
	do
		angsd -b ${COV}X.filelist -anc $ANC -ref $REF -doCounts 1 -baq 1 -C 50 -minMapQ 30 -minQ 20 -minInd 2 -P 2 -GL $MODEL -doSaf 1 -out ${COV}X/GL${MODEL}.${COV}X 
		realSFS -maxIter 100 -P 4 ${COV}X/GL${MODEL}.${COV}X.saf.idx > ${COV}X/GL${MODEL}.${COV}X.sfs
	done
done
Rscript sfs_barplot.R

