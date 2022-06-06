#!/bin/bash -l
#SBATCH -o /home/gmonroe/slurm-log/%j-stdout.txt
#SBATCH -e /home/gmonroe/slurm-log/%j-stderr.txt
#SBATCH -J trimmomatic
#SBATCH -t 96:00:00
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=4G
#SBATCH --partition=bmh
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=gmonroe@ucdavis.edu


PREFIX=$1

module load trimmomatic/0.39

# On Farm, the jar file is located in the $TRIMMOMATIC_HOME variable created
# when trimmomatic module is loaded.
# Specify phred33 or phred64 based on sequencing if known. This prevents reader error and improves speed - newer seq data is -phred33
java -jar $TRIMMOMATIC_HOME/trimmomatic-0.39.jar PE -threads 4 -phred33 \
 fastq/${PREFIX}_1.fastq.gz fastq/${PREFIX}_2.fastq.gz \
  fastq/${PREFIX}_1.trimmed.fastq.gz fastq/${PREFIX}_1un.trimmed.fastq.gz \
  fastq/${PREFIX}_2.trimmed.fastq.gz fastq/${PREFIX}_2un.trimmed.fastq.gz \
  SLIDINGWINDOW:4:20

# Use the trimmed PAIRED reads for next steps

sbatch bwa_REF_R1_R2_PREFIX.sh ~/data/genome/a_thaliana/TAIR10_chr_all.fasta fastq/${PREFIX}_1.trimmed.fastq.gz fastq/${PREFIX}_2.trimmed.fastq.gz $PREFIX
