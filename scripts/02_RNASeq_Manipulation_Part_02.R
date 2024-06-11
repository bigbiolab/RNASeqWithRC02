# load required package
library(tidyverse)
library(GEOquery)
library(ggpubr)
library(openxlsx)
library(naniar)

# import raw counts data
counts_data <- read.csv("data/GSE183947_fpkm.csv")

# get metadata
res <- getGEO(GEO = "GSE183947", GSEMatrix = T)
res
class(res)

# metadata
metadata <- pData(phenoData(res[[1]]))

# subset metadata
metadata_subset <- metadata |>
  select(c(1, 10, 11, 17))

# data preprocessing
metadata_modified <- metadata_subset |>
  rename(tissue = characteristics_ch1, metastasis = characteristics_ch1.1) |>
  mutate(tissue = gsub("tissue: ", "", tissue)) |>
  mutate(metastasis = gsub("metastasis: ", "", metastasis))

# reshaping data
counts_data_long <- counts_data |>
  rename(gene = X) |>
  pivot_longer(-gene,
               names_to = "samples",
               values_to = "fpkm")


# joining data
counts_final <- counts_data_long |>
  left_join(metadata_modified, by = c("samples" = "description"))

# export data
write.csv(counts_final, "data/GSE183947_counts.csv", row.names = F)

