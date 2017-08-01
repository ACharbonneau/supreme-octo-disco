#! /bin/bash

#Launches 20 different randomizations of the dataset (seq 1 20) with a K of ( -t <number range>)

BATCH=${1}
popmin=${2}

#Randomize Input files
tail -n +2 ../${BATCH} > nohead_${BATCH} || exit

NLINES=$(tail -n +2 nohead_${BATCH} | wc -l )
INDIVIDS=`expr ${NLINES} / 2`

MARKERS=$(head -2 ../${BATCH} | tail -1 | wc -w)

sed s/INDIVIDUALSGOHERE/${INDIVIDS}/ ../../../supreme-octo-disco/3.2_mainparams4h > mainparams
sed -i s/MARKERSGOHERE/${MARKERS}/ mainparams


for rep in `seq 1 20`
do seq 2 2 ${NLINES} | shuf > ${rep}_random.txt
head -1 nohead_${BATCH} > ${rep}_${BATCH}

	for i in `cat ${rep}_random.txt`

		do sed "${i}q;d" nohead_${BATCH} >> ${rep}_${BATCH}

		next=$(( ${i}+1 ))

		sed "${next}q;d" nohead_${BATCH} >> ${rep}_${BATCH}

	done

    qsub ../../../supreme-octo-disco/1.6_Random_STRUCTURE.qsub -N ${rep}_STRUCTURE -t 3-${popmin} -v thisfile=${rep}_${BATCH}

    #qsub ../../../../supreme-octo-disco/1.6_Random_STRUCTURE_Long.qsub -N ${rep}_STRUCTURE -t 6-22 -v thisfile=${rep}_${BATCH}

done
