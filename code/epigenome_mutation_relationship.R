library(data.table)
library(ggplot2)

features_data<-fread("data/features_data.csv.gz")
raw_variants<-fread("data/raw_variants.csv")
raw_variants[src %in% c("MA_germline","MA_somatic")]
# annotate features with mutations
# for speed split by chromosome:
MA_training_SNV<-split(raw_variants[src %in% c("MA_germline","MA_somatic") & TYPE=="SNP"], by="CHROM")
MA_training_SNV[]<-lapply(MA_training_SNV, function(x) unique(x$POS))

features_data$MA_SNV<-apply(features_data, 1, function(x){
  sum(x[2]:x[3] %in% MA_training_SNV[[x[1]]])
})

features_data$MA_SNV_pct<-features_data$MA_SNV/features_data$length

sums<-features_data[,.(mut=sum(MA_SNV), length=sum(length)), by=.(region=type %in% c("upstream","downstream"))]
sums$mut/sums$length # reduction in gene body mutation rate 

MA_training_InDel<-split(raw_variants[src %in% c("MA_germline","MA_somatic") & TYPE=="INDEL"], by="CHROM")
MA_training_InDel[]<-lapply(MA_training_InDel, function(x) unique(x$POS))

features_data$MA_InDel<-apply(features_data, 1, function(x){
  sum(x[2]:x[3] %in% MA_training_InDel[[x[1]]])
  
})

features_data$MA_InDel_pct<-features_data$MA_InDel/features_data$length

### build models

SNV_model<-lm(MA_SNV_pct~
            GC_content_pct+
            CG_pct+
            CHG_pct+
            CHH_pct+
            H3K4me2+
            H3K4me1+
            H3K4me3+
            H3K27ac+
            H3K14ac+
            H3K23ac+
            H3K27me1+
            H3K27me3+
            H3K36ac+
            H3K36me3+
            H3K4me1+
            H3K4me2+
            H3K4me3+
            H3K56ac+
            H3K9ac+
            H3K9me1+
            H3K9me2+
            atac_pct+
            Expression, unique(features_data[!is.na(Expression)]))

SNV_model<-MASS::stepAIC(SNV_model, direction="both")

Indel_model<-lm(MA_InDel_pct~
                GC_content_pct+
                CG_pct+
                CHG_pct+
                CHH_pct+
                H3K4me2+
                H3K4me1+
                H3K4me3+
                H3K27ac+
                H3K14ac+
                H3K23ac+
                H3K27me1+
                H3K27me3+
                H3K36ac+
                H3K36me3+
                H3K4me1+
                H3K4me2+
                H3K4me3+
                H3K56ac+
                H3K9ac+
                H3K9me1+
                H3K9me2+
                atac_pct+
                Expression, unique(features_data[!is.na(Expression)]))

Indel_model<-MASS::stepAIC(Indel_model, direction="both")

