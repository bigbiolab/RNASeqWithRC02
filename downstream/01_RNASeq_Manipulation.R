# install required R packages
install.packages(c("tidyverse", "ggpubr", "openxlsx"))

# install required bioconductor packages
BiocManager::install(c("GEOquery", "TCGAbiolinks", "DESeq2", "airway"))

# load required package
library(tidyverse)
library(GEOquery)
library(ggpubr)
library(openxlsx)
library(naniar)


# import data
data <- read.csv("data/GSE183947_fpkm_long.csv")

# data exploration
# 1. dimension of data
dim(data)
ncol(data)
nrow(data)

# 2. examine first few rows
head(data)
head(data, 10)
head(data, n = 10)

# 3. examine last few rows
tail(data)
tail(data, 10)
tail(data, n = 10)

# 4. sampling
sample(data)
sample_n(data, 100)
sample_frac(data, 0.25)

# 5. Is there any missing values?
is.na(data)
sum(is.na(data))
miss_var_summary(data)
gg_miss_var(data)
miss_var_which(data)

# data manipulation
# 1. select (sub-setting column)

# 1.1. select single column by col number
select(data, 1)

# 1.2. select multiple columns by col number
select(data, c(1, 3 , 6))

# 1.3. select range of columns using : operator
select(data, 1:3)

# 1.4. select single column by col name
select(data, gene)

# 1.4. select multiple columns by col name
select(data, gene, title)

# 2. filter
# 2.1. filter data using (==)
filter(data, metastasis == "yes")

# 2.2. filter data using (>)
filter(data, fpkm > 10)


# 2.3. filter data using (<)
filter(data, fpkm < 10)


# 2.4. filter data using (>=)
filter(data, fpkm >= 10)

# 2.5. filter data using (<=)
filter(data, fpkm <= 10)

# 2.6. filter data using (&)
filter(data, metastasis == "yes" & fpkm > 10)

# 2.7. filter data using (|)
filter(data, metastasis == "yes" | fpkm > 10)


# select and filter
new_data <- select(data, gene, metastasis, fpkm)
filter(new_data, metastasis == "yes")

# chaining method (pipe operator |> = clt + shift + m )
data |>
  select(gene, metastasis, fpkm) |>
  filter(metastasis == "yes") |>
  head()

# multiple filtering criteria (%in%)
data |>
  filter(gene %in% c("BRCA1", "BRCA2", "TP53", "ALK", "MYCN")) |>
  head()

# 3. mutate (creating column)
data |>
  mutate(fpkm_log = log(fpkm)) |>
  head()

# 4. grouping and summarizing
data |>
  filter(gene == "BRCA1" | gene == "BRCA2") |>
  group_by(tissue) |>
  summarise(mean(fpkm))

# which genes?
data |>
  filter(gene == "BRCA1" | gene == "BRCA2") |>
  group_by(tissue, gene) |>
  summarise(mean(fpkm))

# giving summary column name
data |>
  filter(gene == "BRCA1" | gene == "BRCA2") |>
  group_by(tissue, gene) |>
  summarise(mean_fpkm = mean(fpkm),
            median_fpkm = median(fpkm))

# 5. arrange
data |>
  filter(gene == "BRCA1" | gene == "BRCA2") |>
  group_by(tissue, gene) |>
  summarise(mean_fpkm = mean(fpkm),
            median_fpkm = median(fpkm)) |>
  arrange(mean_fpkm)

# desc order
data |>
  filter(gene == "BRCA1" | gene == "BRCA2") |>
  group_by(tissue, gene) |>
  summarise(mean_fpkm = mean(fpkm),
            median_fpkm = median(fpkm)) |>
  arrange(desc(mean_fpkm))
