# Install tximport 
BiocManager::install("tximport")

# load all required packages 
library(tidyverse)
library(tximport)
library(DESeq2)
library(EnsDb.Hsapiens.v86)
library(EnhancedVolcano)
library(pheatmap)

# What are the columns in the EnsDb.Hsapiens.v86? 
columns(EnsDb.Hsapiens.v86)

# Get the TXID and SYMBOL columns for all entries in the database 
tx2gene <- AnnotationDbi::select(EnsDb.Hsapiens.v86, 
                      keys = keys(EnsDb.Hsapiens.v86), 
                      columns = c('TXID', 'SYMBOL'))

# Remove the gene ID column
tx2gene <- dplyr::select(tx2gene, -GENEID)

# Get the `quant` files and `metadata` 
# Collect the samples quant files 
samples <- list.dirs("upstream/Salmon.out/", recursive = FALSE, full.names = FALSE)

quant_files <- file.path("upstream/Salmon.out", samples, "quant.sf")

names(quant_files) <- samples 
print(quant_files)

# Ensure each file actually exists 
# All should be TRUE 
file.exists(quant_files)

# metadata / col_data data frame 
col_data <- data.frame(
  row.names = samples, 
  condition = rep(c("untreated", "dex"), 4)
)

# Get the tximport counts object / counts_data 
counts_data <- tximport(files = quant_files, 
         type = "salmon", 
         tx2gene = tx2gene, 
         ignoreTxVersion = TRUE)


# Make DESeq object 
dds <- DESeqDataSetFromTximport(
  txi = counts_data, 
  colData = col_data,
  design = ~condition
)

# --PCA 
?vst
vsd <- vst(dds)
plotPCA(vsd)

# Perform DEG analysis 
dds <- DESeq(dds)

# Obtain result 
res <- results(dds)





