library(data.table)

#####

variants<-fread("data/raw_variants.csv")

# annotaiton file source and cleanup
#download.file("https://www.arabidopsis.org/download_files/Genes/TAIR10_genome_release/TAIR10_gff3/TAIR10_GFF3_genes.gff", destfile="data/TAIR10_GFF3_genes.gff")
annotation<-fread("data/TAIR10_GFF3_genes.gff")
setnames(annotation, c("V1","V3","V4","V5"),c("chr", "type", "start", "stop"))
annotation$chr<-gsub("Chr","",annotation$chr)

# polymorphology contains functions to visualize variation in relation to TSS and TTS of gene bodies
# install if needed:
#library(devtools)
#install_github("greymonroe/polymorphology")
library(polymorphology)
tss_view<-tss_tts.variants(gff = annotation, vcf=variants)
tss_tts.variants.plot(tss_view)
