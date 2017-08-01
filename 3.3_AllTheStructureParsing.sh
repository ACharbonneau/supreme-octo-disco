#! /bin/bash


NUMINDS=$(grep NUMINDS mainparams | cut -f 3 -d " ")
NUMIND=`expr ${NUMIND} + 1`

for i in `ls *_f`
	do echo $i
	grep -A 2 "Estimated Ln Prob of Data" $i
	done > AlltheProbabilities.txt

sed -i -E '/^([0-9]+)_.+-([0-9])+_f$/ N
{/^([0-9]+)_.+-([0-9])+_f\nEstimated\sLn\sProb\sof\sData\s+\=\s(\-*[0-9]+\.*[0-9]+)$/ N
{/^([0-9]+)_.+-([0-9])+_f\nEstimated\sLn\sProb\sof\sData\s+\=\s(\-*[0-9]+\.*[0-9]+)\nMean\svalue\sof\sln\slikelihood\s\=\s(\-*[0-9]+\.*[0-9]+)$/ N
{s/^([0-9]+)_.+-([0-9])+_f\nEstimated\sLn\sProb\sof\sData\s+\=\s(\-*[0-9]+\.*[0-9]+)\nMean\svalue\sof\sln\slikelihood\s\=\s(\-*[0-9]+\.*[0-9]+)\nVariance\sof\sln\slikelihood\s+\=\s(\-*[0-9]+\.*[0-9]+)/\1,\2,\3,\4,\5/
}
}
}' AlltheProbabilities.txt


for i in `ls *_f`
	do echo $i
	grep -A 2 "Estimated Ln Prob of Data" $i
	done > AlltheProbabilities.txt

for i in `ls *_f`
	do grep -A ${NUMINDS} "Inferred ancestry of individuals" $i > $i.forparse
done

for i in `ls *forparse`
	do python ../../../../supreme-octo-disco/1.7_structureparse.py $i
done

mkdir parsed_data
mkdir forparse
mkdir raw_output
mkdir error_output


mv *_f.parsed parsed_data/
mv *_f.forparse forparse
mv *_f raw_output
mv *.[eo]* error_output
