# This launches any number of catalog build qsubs, and can be customized by dataset by 
# changing the file list. 

# Build the catalog; the "&>>" will capture all output and append it to the Log file.

# AE specific catalogs




# -g,--aligned — base catalog construction on alignment position, not sequence identity.
# -p processors
# -b assign batchID
# -n — number of mismatches allowed between sample loci when build the catalog
# -o — output path to write results

files="../../../Metadata/AE_F0_cs_stacks_list
../../../Metadata/AE_F1_cs_stacks_list
../../../Metadata/AE_F2_cs_stacks_list
../../../Metadata/SS_cs_stacks_list"

for filename in $files
do qsub -N `basename ${filename}` -v InputFile="${filename}" ../../../supreme-octo-disco/2.1_cs_stacks.qsub
done


# Assuming it's a cross


cp ../../../supreme-octo-disco/2.1_cs_stacks.qsub ../../../supreme-octo-disco/2.1_cs_mapping.qsub


sed -i "s/sstacks.*//" ../../../supreme-octo-disco/2.1_cs_mapping.qsub

echo 'sstacks -g -p 20 -b ${batchID} -c ${batchID} -s `cat AE_F2_cs_stacks_list` -o . F2_F0_Mapping.log' >> ../../../supreme-octo-disco/2.1_cs_mapping.qsub

qsub -N `basename ${filename}` -v InputFile="${filename}" ../../../supreme-octo-disco/2.1_cs_stacks.qsub