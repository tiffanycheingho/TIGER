#!/bin/bash

#PURPOSE: Separates motion parameters into separate files 
#USAGE: ASSUMES THIS IS TO BE RUN ON VM******

timepoint="-T2" #XXX change if needed
rootdir="/DATA/TIGER_RSFC_Analysis/"
subjdirs="Subjects"
activedir="/DATA/TIGER-T2" 

echo "--------------------------------------------------------------"
echo "**************************************************************"
date
echo "RUN THIS BEFORE RUNNING A05b_CreateNuisanceRegressors.R"
echo "**************************************************************"

for subject in XX; do #XXX THIS IS WHERE SUBJECT ID SHOULD BE INPUTTED (YOU CAN HAVE MANY SUBJ ID HERE SEPARATED BY SPACE)
 
	if [ -d ${rootdir}/${subjdirs}/${subject}/Analysis ] && [ -e ${rootdir}/${subjdirs}/${subject}/Analysis/mcplots.par ] ; then

		echo "***going into ${subject} Analysis***"
		
			cd ${rootdir}/${subjdirs}/${subject}/Analysis

			echo "--------------------------------"
			echo "PARSING MCPLOTS FOR ${subject}"
			echo "--------------------------------"
			

			# 1. Separate motion parameters into separate files
			cp mcplots.par mcplots.1D
			awk '{print $1}' mcplots.1D > mcplots1.1D
			awk '{print $2}' mcplots.1D > mcplots2.1D
			awk '{print $3}' mcplots.1D > mcplots3.1D
			awk '{print $4}' mcplots.1D > mcplots4.1D
			awk '{print $5}' mcplots.1D > mcplots5.1D
			awk '{print $6}' mcplots.1D > mcplots6.1D
		
			# 2. 
			echo "****** Run R script to get all the nuisance regressors *************************"
			echo "##File:   A05b_CreateNuisanceRegressors.R"
	
	fi
done