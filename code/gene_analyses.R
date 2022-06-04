library(data.table)
library(ggplot2)

# gene level data contains epigenomic, functional, and mutation data for coding regions of each gene
gene_data<-fread("data/gene_level_data.csv")

# we can examine for example, mutation rates in essential vs non-essential functional categories of genes
# CLB = "Cellular/Biochemical"
# CND = "Environmental" (Conditional)
# MRP = "Morphological"
# ESN = "Essential"
mutation_essentiality<-gene_data[essentiality!="" ,.(mutations=sum((SNV+InDel)*`CDS length`), length=sum(`CDS length`)), by=.(essentiality)] 
summary(lm(Expression~essentiality, gene_data))

ggplot(mutation_essentiality, aes(x=essentiality, y=mutations/length))+ 
  geom_bar(stat="identity")
