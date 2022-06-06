#!/bin/bash -l
#SBATCH -o /home/gmonroe/slurm-log/%j-stdout.txt
#SBATCH -e /home/gmonroe/slurm-log/%j-stderr.txt
#SBATCH -J bwa
#SBATCH -t 72:00:00
#SBATCH --mem 8G
#SBATCH -n 1
#SBATCH --partition=bmh
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=greymonroe@gmail.com
set -e
set -u

set -xv

REF=$1
READ1=$2
READ2=$3
PREFIX=$4

module load bamtools
bwa mem -t 32 -R "@RG\tID:$PREFIX\tSM:$PREFIX\tPL:ILLUMINA" $REF $READ1 $READ2 | samtools sort -n -@5 -o bam/$PREFIX.bam

samtools fixmate -m bam/$PREFIX.bam - | samtools sort -@5 -o bam/$PREFIX.fix.bam

samtools markdup -@5 -s bam/$PREFIX.fix.bam - | samtools sort -@5 -o  bam/$PREFIX.fix.markdup.bam

samtools index bam/$PREFIX.fix.markdup.bam

sbatch gatk_hc_REF_PREFIX.sh $REF $PREFIX
