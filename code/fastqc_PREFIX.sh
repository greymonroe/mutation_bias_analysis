#!/bin/bash -l
#SBATCH -o /home/gmonroe/slurm-log/%j-stdout.txt
#SBATCH -e /home/gmonroe/slurm-log/%j-stderr.txt
#SBATCH -J fastqc
#SBATCH -t 96:00:00
#SBATCH --ntasks=4
#SBATCH --mem-per-cpu=32G
#SBATCH --partition=bmh
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=gmonroe@ucdavis.edu


PREFIX=$1

module load fastqc/0.11.9

fastqc --threads 8 fastq/${PREFIX}_1.fastq.gz --outdir= fastqc
fastqc --threads 8 fastq/${PREFIX}_1.trimmed.fastq.gz --outdir= fastqc
fastqc --threads 8 fastq/${PREFIX}_2.fastq.gz --outdir= fastqc
fastqc --threads 8 fastq/${PREFIX}_2.trimmed.fastq.gz --outdir= fastqc

