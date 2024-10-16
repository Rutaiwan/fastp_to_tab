#!/usr/bin/env bash

# USAGE: bash fastp_into_tab.bash isolate_list.txt /path_to_output_directory

# Example command: bash fastp_into_tab.bash /srv/rutaiwan/ecoli_all_list.txt /home/rdusadeepong/DATA/Ecoli/readQC/fastp/ 
##start where you are in fastp_output_folder

##YOU NEED TO SORT YOUR LIST INTO ORDER FIRST!!

LIST=$1
OUTDIR=$2

cd $OUTDIR

for id in `cat $LIST`; do 
		grep -rnw ${id}.json -e "total_reads\|total_bases\|q30_bases\|q30_rate\|gc_content\|read1_mean_length\|read2_mean_length" >> ${id}.tsv
		sed 's/\t/,/g' ${id}.tsv > ${id}_d.csv ##change tsv to csv
		csvcut -c 4 ${id}_d.csv > ${id}_cut.csv
		sed -i 's/:/,/g' ${id}_cut.csv
		csvcut -c 2 ${id}_cut.csv > ${id}_num.csv
		csvtk transpose ${id}_num.csv > ${id}_transpose.csv
		cat *_transpose.csv > all_combine.csv
		paste -d , $LIST all_combine.csv > all_id_final.csv
		echo -e "ID,total_reads_before_filtering,total_bases_before_filtering,q30_bases_before_filtering,q30_rate_before_filtering,read1_mean_length_before_filtering,read2_mean_length_before_filtering,gc_content_before_filtering,total_reads_after_filtering,total_bases_after_filtering,q30_bases_after_filtering,q30_rate_after_filtering,read1_mean_length_after_filtering,read2_mean_length_after_filtering,gc_content_after_filtering" | cat - all_id_final.csv > all_id_final_headers.csv
	done
	
##Clean the folder
rm *transpose*.csv
rm *num*.csv
rm *cut*.csv
rm *_d*.csv
rm *.tsv
