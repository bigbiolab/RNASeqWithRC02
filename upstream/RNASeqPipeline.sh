#!/bin/bash 

# Installation 
# -- Install SRA-toolkit: conda install bioconda::sra-tools
# -- Install salmon: conda install bioconda::salmon

# Run the script 
# -- Give permission: chmod 555 RNASeqPipeline.sh
# -- Run the script: ./RNASeqPipeline.sh

# Step 1. Declare alist containing SRA sample IDs to be downloaded and quantitfied 
samples_to_quant=(SRR6035978 SRR6035979 SRR6035980 SRR6035981 SRR6035982 SRR6035983)

# Step 2. Loop through each sample ID in the list 
for sample in "${samples_to_quant[@]}"
do 
  echo "Processing $sample"
  
  # Step 3. Excute the `prefetch` command to download the .sra into a directory named after the sample 
  SECONDS=0
  echo "Starting prefetch for $sample"
  prefetch -O $sample/$sample 
  prefetch_time=$SECONDS
  echo "Prefetch completed for $sample in $prefetch_time"
  
  # Step 4. Execute the `fasterq-dump` command to convert the .sra file into a .fastq file.
  SECONDS=0 
  echo "Starting fasterq-dump for $sample"
  fasterq-dump -e 14 -p -O $sample/ $sample/$sample/$sample.sra
  fasterq_dump_time=$SECONDS
  echo "Fasterq-dump completed for $sample in $fasterq_dump_time seconds."
  
  # Step 5. Run `salmon` to quantify all the samples 
  SECONDS=0
  echo "Starting salmon $sample"
  salmon quant -l A -1 $sample/$sample.sra_1.fastq -2 $sample/$sample.sra_2.fastq  --validateMappings -i ~/hg38/salmon_partial_sa_index/default/ -o Salmon.out/$sample -p 15
  samlon_time=$SECONDS
  echo "Salmon completed for $sample in $samlon_time seconds."
  
  # Calculate total time and print the total processing time for each sample 
  total_time=$((prefetch_time+fasterq_dump_time+samlon_time))
  echo "Total processing time for $sample: $total_time seconds."
done 