#!/bin/sh -login

#Starting in Mapping folder
# Mapped to Moghe

#Signatures of Selection

#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="SS",stackslist="SS_stacks_list",cslist="SS_cs_stacks_list",popfile="SS_data.pop",popmin="20",indivmin=".75"
#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrl",stackslist="SS_Rrl_stacks_list",cslist="SS_Rrl_cs_stacks_list",popfile="SS_data.pop",popmin="6",indivmin=".75"
qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrr",stackslist="SS_Rrr_stacks_list",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".75",m=3
qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrr",stackslist="SS_Rrr_stacks_list",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".75",m=2
qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrr",stackslist="SS_Rrr_stacks_list",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".75",m=1

#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rsat",stackslist="SS_Rsat_stacks_list",cslist="SS_Rsat_cs_stacks_list",popfile="SS_data.pop",popmin="8",indivmin=".75"
#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="RrrRrl",stackslist="SS_RrrRrl_stacks_list",cslist="SS_RrrRrl_cs_stacks_list",popfile="SS_data.pop",popmin="11",indivmin=".75"
qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrr",stackslist="SS_Rrr_stacks_list",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".5",m=3
qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrr",stackslist="SS_Rrr_stacks_list",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".5",m=2
qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="Rrr",stackslist="SS_Rrr_stacks_list",cslist="SS_Rrr_cs_stacks_list",popfile="SS_data.pop",popmin="5",indivmin=".5",m=1

#Anther Exsertion

#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="AE0",stackslist="AE_F0_stacks_list",cslist="AE_F0_cs_stacks_list",popfile="AE_data.pop",popmin="4",indivmin=".75"
#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="AE1",stackslist="AE_F1_stacks_list",cslist="AE_F1_cs_stacks_list",popfile="AE_data.pop",popmin="8",indivmin=".75"
#sub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="AE2",stackslist="AE_F2_stacks_list",cslist="AE_F2_cs_stacks_list",popfile="AE_data.pop",popmin="4",indivmin=".75"
#qsub ../../supreme-octo-disco/1.4.1_stacks_analysis.qsub -v dataAbv="AEMap",stackslist="AE_Mapping_stacks_list",cslist="AE_Mapping_cs_stacks_list",popfile="AE_data.pop",popmin="8",indivmin=".75"
