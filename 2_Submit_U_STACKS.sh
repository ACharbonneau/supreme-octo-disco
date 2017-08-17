#!/bin/sh -login

#No Mapping, just aligning stacks

#cd ../ || exit
#Signatures of Selection

m=5
M=7

qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-80 -v dataAbv="Rrr",Ustackslist="SS_Rrr_stacks_fastqs",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".80",m=${m},M=${M},n=${M}
qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-259 -v dataAbv="SS",Ustackslist="SS_stacks_fastqs",cslist="SS_cs_stacks_list",popfile="SS_data.pop",popmin="20",indivmin=".80",m=${m},M=${M},n=${M}
qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-96 -v dataAbv="Rrl",Ustackslist="SS_Rrl_stacks_fastqs",cslist="SS_Rrl_cs_stacks_list",popfile="SS_data.pop",popmin="6",indivmin=".80",m=${m},M=${M},n=${M}
qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-51 -v dataAbv="Rsat",Ustackslist="SS_Rsat_stacks_fastqs",cslist="SS_Rsat_cs_stacks_list",popfile="SS_data.pop",popmin="8",indivmin=".80",m=${m},M=${M},n=${M}
qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-176 -v dataAbv="RrrRrl",Ustackslist="SS_RrrRrl_stacks_fastqs",cslist="SS_RrrRrl_cs_stacks_list",popfile="SS_data.pop",popmin="11",indivmin=".80",m=${m},M=${M},n=${M}


#Anther Exsertion

qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-85 -v dataAbv="AE0",Ustackslist="AE_F0_stacks_fastqs",cslist="AE_F0_cs_stacks_list",popfile="AE_data.pop",popmin="4",indivmin=".80",m=${m},M=${M},n=${M}
#qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-80 -v dataAbv="AE1",Ustackslist="AE_F1_stacks_fastqs",cslist="AE_F1_cs_stacks_list",popfile="AE_data.pop",popmin="8",indivmin=".80",m=${m},M=${M},n=${M}
#qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-1001 -v dataAbv="AE2",Ustackslist="AE_F2_stacks_fastqs",cslist="AE_F2_cs_stacks_list",popfile="AE_data.pop",popmin="4",indivmin=".80",m=${m},M=${M},n=${M}
#qsub ../supreme-octo-disco/2.1_U_stacks_analysis.qsub -t 1-1086 -v dataAbv="AEMap",Ustackslist="AE_Mapping_stacks_fastqs",cslist="AE_Mapping_cs_stacks_list",popfile="AE_data.pop",popmin="8",indivmin=".80",m=${m},M=${M},n=${M}
