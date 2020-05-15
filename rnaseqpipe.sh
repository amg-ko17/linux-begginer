#!/usr/bin/bash
#Author: Adenrele Gleason

# letting the shell where my programs are. If you do not do this, you wont be able to run the programs

source /etc/profile.d/markcbm.sh

# data prep
cp -R /home/manager/linux Desktop/.
cd ~/Desktop/linux/advanced/rnaseq/


#step 1 fastqc analysis
fastqc fastq/*.fastq

#step 2building index
cd index
bowtie-build mm9_chr1.fa mm9_chr1
cd ..


# step 3alignment
tophat2  -G mm9_chr1.gtf -o  tophat_wt/  index/mm9_chr1 fastq/myoblast_wt.fastq
tophat2  -G mm9_chr1.gtf -o  tophat_del/  index/mm9_chr1 fastq/myoblast_del.fastq

# step 4 check ouputs_tophat
ls
ls tophat_wt
ls tophat_del
cat tophat_wt/align_summary.txt
cat tophat_del/align_summary.txt

# step 5 index 
# this command is indexing the aligned data to the 
samtools index tophat_wt/accepted_hits.bam
samtools19 index tophat_del/accepted_hits.bam


# step 6 differential expression analysis
#-L labeling first sample is wt the second is deletion (del)
#-- no update-check--> the means not to search the internet 
#-o cuffdiff_out--> this is telling you that o the output file is cuffdiff_out; all the information is going into this folder
cuffdiff --no-update-check -o cuffdiff_out -L wt,del mm9_chr1.gtf tophat_wt/accepted_hits.bam tophat_del/accepted_hits.bam

# step 7 listing everything in this folder lh this the long list
ls -lh cuffdiff_out

echo "The RNA-seq pipeline is complete"







