#!/bin/bash -l
#SBATCH -o /home/gmonroe/slurm-log/%j-stdout.txt
#SBATCH -e /home/gmonroe/slurm-log/%j-stderr.txt
#SBATCH -J gatk
#SBATCH -t 144:00:00
#SBATCH --mem 32G
#SBATCH -n 8
#SBATCH --partition=bmh
#SBATCH --mail-type=ALL

set -e
set -u
set -xv

REF=$1
PREFIX=$2
module load GATK

# --pcr-indel-model CONSERVATIVE if the libraries are not PCR-free
gatk --java-options "-Xmx32G -Djava.io.tmpdir=./tmp" HaplotypeCaller \
	-R $REF   \
	-I bam/$PREFIX.fix.markdup.bam \
	-O vcf/$PREFIX.vcf.gz \
	--pcr-indel-model NONE \
-A StrandBiasBySample \
	--read-filter NotDuplicateReadFilter 

