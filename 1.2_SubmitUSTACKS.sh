#!/bin/sh -login

#No Mapping, just aligning stacks

#cd ../ || exit
#Signatures of Selection

for m in `seq 1 7`
  do for M in `seq 1 8`
    do qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="Rrr",Ustackslist="SS_Rrr_stacks_fastqs",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".80",m=${m},M=${M},n=${M}
    qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="Rrr",Ustackslist="SS_Rrr_stacks_fastqs",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".80",m=${m},M=${M},n=`expr ${M} - 1`
    qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="Rrr",Ustackslist="SS_Rrr_stacks_fastqs",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".80",m=${m},M=${M},n=`expr ${M} + 1`
  done
done

#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="SS",Ustackslist="SS_stacks_fastqs",cslist="SS_cs_stacks_list",popfile="SS_data.pop",popmin="20",indivmin=".75"
#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="Rrl",Ustackslist="SS_Rrl_stacks_fastqs",cslist="SS_Rrl_cs_stacks_list",popfile="SS_data.pop",popmin="6",indivmin=".75"
#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="Rsat",Ustackslist="SS_Rsat_stacks_fastqs",cslist="SS_Rsat_cs_stacks_list",popfile="SS_data.pop",popmin="8",indivmin=".75"
#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="RrrRrl",Ustackslist="SS_RrrRrl_stacks_fastqs",cslist="SS_RrrRrl_cs_stacks_list",popfile="SS_data.pop",popmin="11",indivmin=".75"


#Anther Exsertion

#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="AE0",Ustackslist="AE_F0_stacks_fastqs",cslist="AE_F0_cs_stacks_list",popfile="AE_data.pop",popmin="4",indivmin=".75"
#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="AE1",Ustackslist="AE_F1_stacks_fastqs",cslist="AE_F1_cs_stacks_list",popfile="AE_data.pop",popmin="8",indivmin=".75"
#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="AE2",Ustackslist="AE_F2_stacks_fastqs",cslist="AE_F2_cs_stacks_list",popfile="AE_data.pop",popmin="4",indivmin=".75"
#qsub ../supreme-octo-disco/1.4.1_Ustacks_analysis.qsub -v dataAbv="AEMap",Ustackslist="AE_Mapping_stacks_fastqs",cslist="AE_Mapping_cs_stacks_list",popfile="AE_data.pop",popmin="8",indivmin=".75"
