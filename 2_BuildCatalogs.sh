# This launches any number of catalog build qsubs, and can be customized by dataset by 
# changing the file list. 

# Build the catalog; the "&>>" will capture all output and append it to the Log file.

# AE specific catalogs


#Start in cs_stacks

# -g,--aligned — base catalog construction on alignment position, not sequence identity.
# -p processors
# -b assign batchID
# -n — number of mismatches allowed between sample loci when build the catalog
# -o — output path to write results

files="../../../Metadata/AE_F0_cs_stacks_list
../../../Metadata/AE_F1_cs_stacks_list
../../../Metadata/AE_F2_cs_stacks_list
../../../Metadata/SS_cs_stacks_list"

dt=`date '+%Y%m%d'`

ID=0

for file in ${files};
    do batchID="${dt}${ID}" 
    qsub -N `basename ${file}` -v InputFile="${file}",outputfolder=`basename ${file}`,batchID="${batchID}" ../../../supreme-octo-disco/2.1_cs_stacks.qsub
    ID=`expr ${ID} + 1`
done


# Assuming it's a cross

cp ../../../supreme-octo-disco/2.1_cs_stacks.qsub ../../../supreme-octo-disco/2.1_cs_mapping.qsub

sed -i "s/sstacks.*//" ../../../supreme-octo-disco/2.1_cs_mapping.qsub

echo 'sstacks -g -p 20 -b ${batchID} -c ${batchID} -s `cat AE_Mapping_cs_stacks_list` -o . F0_F2_Mapping.log' >> ../../../supreme-octo-disco/2.1_cs_mapping.qsub

batchID="${dt}${ID}"

qsub -N Mapping_F0_F2 -v InputFile="../../../Metadata/AE_Mapping_cs_stacks_list",outputfolder="AE_F0_F2",batchID="${batchID}" ../../../supreme-octo-disco/2.1_cs_stacks.qsub