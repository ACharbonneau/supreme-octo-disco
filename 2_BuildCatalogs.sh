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

dt=`date '+%Y%m%d'`

expandedfiles=
ID=0

for file in ${files};
    do needsexpand=`cat ${file}`
    batchID="${dt}${ID}" 
    for unexpandableline in ${needsexpand}
        do echo " -s " ls ${unexpandableline}.tags.tsv | sed "s/.tags.tsv//" | sed "s/ls //" 
    done | tr -d '\n' > ${file}.expanded
    qsub -N `basename ${file}`.expanded -v InputFile="${file}.expanded",outputfolder=`basename ${file}`,batchID="${batchID}" ../../../supreme-octo-disco/2.1_cs_stacks.qsub
    ID=`expr ${ID} + 1`
done





# Assuming it's a cross


cp ../../../supreme-octo-disco/2.1_cs_stacks.qsub ../../../supreme-octo-disco/2.1_cs_mapping.qsub


sed -i "s/sstacks.*//" ../../../supreme-octo-disco/2.1_cs_mapping.qsub

echo 'sstacks -g -p 20 -b ${batchID} -c ${batchID} -s `cat AE_F2_cs_stacks_list` -o . F2_F0_Mapping.log' >> ../../../supreme-octo-disco/2.1_cs_mapping.qsub

batchID="${dt}${ID}"

qsub -N Mapping_F0_F2 -v InputFile="../../../Metadata/AE_F0_cs_stacks_list.expanded",outputfolder="AE_F0_F1",batchID="${batchID}" ../../../supreme-octo-disco/2.1_cs_stacks.qsub