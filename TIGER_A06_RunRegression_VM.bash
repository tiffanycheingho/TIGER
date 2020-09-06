#!/bin/bash

#AUTHORS:  SO AND TH
#LAST UPDATED: TH 2018 February
#NOTES: DO NOT RUN THIS UNTIL A05 scripts are run

#*******ASSUMES THIS IS TO BE RUN ON VM******
rootdir="/DATA/TIGER_RSFC_Analysis/"
subjdirs="Subjects"

echo "--------------------------------------------------------------"
echo "**************************************************************"
date
echo "running A06_RunNuisanceRegression.bash...MAKE SURE A05 SCRIPTS ARE RUN FIRST!"
echo "**************************************************************"

for subject in XXX; do #XXX change subject ID

	if [ -e ${rootdir}/${subjdirs}/${subject}/Analysis/mcplots6_233t-1_sq.1D ] ; then
					
			
	#the following checks if the final mcplot final is created from the R script
		
			cd ${rootdir}/${subjdirs}/${subject}/Analysis/

			echo --------------------------------
			echo "FINISHING NUISANCE REGRESSION for ${subject}: STAND BACK!"
			echo --------------------------------

			echo "**** Removing 1st volume from already-shortened rest data so that it is comparable in length to everything else" 
			# Remember, this counts from 0
			3dcalc -a rest_raw_rdptkmas.nii.gz[1..233] -expr 'a' -prefix rest_raw_rdptkmas233.nii.gz

			#
			## As per http://www.nitrc.org/forum/forum.php?thread_id=1495&forum_id=1383 (accessed Feb 5, 2015), which provided the following model script (Clare Kelly says use polort 0 since linear and quadratic trends are removed during preprocessing)
			
				#echo "Running 3dDeconvolve to get matrix"
				#3dDeconvolve \
				#-input rest_raw_rdptkmas.nii.gz \
				#-polort 0 \
				#-num_stimts 8 \
				#-stim_file 1 mcplots1.1D \
				#-stim_file 2 mcplots2.1D \
				#-stim_file 3 mcplots3.1D \
				#-stim_file 4 mcplots4.1D \
				#-stim_file 5 mcplots5.1D \
				#-stim_file 6 mcplots6.1D \
				#-stim_file 7 995-T1_csf.1D \
				#-stim_file 8 995-T1_wm.1D \
				#-x1D XX-T1_nuisance \
				#-xjpeg XX-T1_nuisance.png \
				#-x1D_stop
			
				#echo "Running 3dREMLfit to get residuals"
				#3dREMLfit \
				#-input rest_raw_rdptkmas.nii.gz \
				#-matrix 995-T1_nuisance.xmat.1D \
				#-Rerrts 995-T1_res4d.nii.gz \
				#-GOFORIT
			
			# From above script, I added additional nuisance regressors to get:
			echo "**** Running 3dDeconvolve to get matrix"
			3dDeconvolve \
			-input rest_raw_rdptkmas233.nii.gz \
			-polort 0 \
			-num_stimts 26 \
			-stim_file 1 "mcplots1_233.1D" -stim_base 1 \
			-stim_file 2 "mcplots2_233.1D" -stim_base 2 \
			-stim_file 3 "mcplots3_233.1D" -stim_base 3 \
			-stim_file 4 "mcplots4_233.1D" -stim_base 4 \
			-stim_file 5 "mcplots5_233.1D" -stim_base 5 \
			-stim_file 6 "mcplots6_233.1D" -stim_base 6 \
			-stim_file 7 "mcplots1_233t-1.1D" -stim_base 7 \
			-stim_file 8 "mcplots2_233t-1.1D" -stim_base 8 \
			-stim_file 9 "mcplots3_233t-1.1D" -stim_base 9 \
			-stim_file 10 "mcplots4_233t-1.1D" -stim_base 10 \
			-stim_file 11 "mcplots5_233t-1.1D" -stim_base 11 \
			-stim_file 12 "mcplots6_233t-1.1D" -stim_base 12 \
			-stim_file 13 "mcplots1_233sq.1D" -stim_base 13 \
			-stim_file 14 "mcplots2_233sq.1D" -stim_base 14 \
			-stim_file 15 "mcplots3_233sq.1D" -stim_base 15 \
			-stim_file 16 "mcplots4_233sq.1D" -stim_base 16 \
			-stim_file 17 "mcplots5_233sq.1D" -stim_base 17 \
			-stim_file 18 "mcplots6_233sq.1D" -stim_base 18 \
			-stim_file 19 "mcplots1_233t-1_sq.1D" -stim_base 19 \
			-stim_file 20 "mcplots2_233t-1_sq.1D" -stim_base 20 \
			-stim_file 21 "mcplots3_233t-1_sq.1D" -stim_base 21 \
			-stim_file 22 "mcplots4_233t-1_sq.1D" -stim_base 22 \
			-stim_file 23 "mcplots5_233t-1_sq.1D" -stim_base 23 \
			-stim_file 24 "mcplots6_233t-1_sq.1D" -stim_base 24 \
			-stim_file 25 "${subject}_csf_233.1D" -stim_base 25 \
			-stim_file 26 "${subject}_wm_233.1D" -stim_base 26 \
			-x1D ${subject}_nuisance \
			-xjpeg ${subject}_nuisance.png \
			-x1D_stop
			##NOTE: I didn't mask.  Afni does not recommend (see "masking note" in http://afni.nimh.nih.gov/pub/dist/doc/program_help/afni_proc.py.html)
			
			echo "Running 3dREMLfit to get residuals"
			3dREMLfit \
			-input rest_raw_rdptkmas233.nii.gz \
			-matrix ${subject}_nuisance.xmat.1D \
			-Rerrts rest_raw_rdptkmas233n.nii.gz \
			-GOFORIT
			
			
			echo "*********** d: Demeaning residuals and ADDING 100 (to avoid potential problems in FEAT)"
			# Below I've added demeaning because of this:
	
			3dTstat -mean -prefix rest_raw_rdptkmas233n_mean.nii.gz rest_raw_rdptkmas233n.nii.gz
			3dcalc -a rest_raw_rdptkmas233n.nii.gz -b rest_raw_rdptkmas233n_mean.nii.gz -expr '(a-b)+100' -prefix rest_raw_rdptkmas233nd_100outsidebrain.nii.gz
			#Mask the brain (with rest data because rest doesn't exactly line up to template) so that stuff outside the brain isn't included
			3dcalc -a rest_raw_rdptkmas233n.nii.gz -expr 'notzero(a)' -prefix rest_raw_rdptkmas233n_masked.nii.gz
			#Now apply this mask to the brain
			3dcalc -a rest_raw_rdptkmas233n_masked.nii.gz -b rest_raw_rdptkmas233nd_100outsidebrain.nii.gz -expr 'a*b' -prefix rest_raw_rdptkmas233nd.nii.gz


			#################################################################
			##### Bandpass filter
			#################################################################
			# NOTE: If want to do bp filter simultaneously with nuisance (Hallquist 2013 NI), then use -ort option.  
			# NOTE: I opted not to do this because the data (e.g., Jo 2013) showing that 1)nuisance 2)bp ordering is sufficient
			
			echo "Bandpass filtering"
			3dBandpass -prefix rest_raw_rdptkmas233ndb.nii.gz -automask 0.009 0.080 rest_raw_rdptkmas233nd.nii.gz
		
			echo "************** checking for" ${subject} "final file *******************"
			ls rest_raw_rdptkmas233ndb.nii.gz

			echo "**************" ${subject} "3dDeconvolve.err's file *******************"
			cat 3dDeconvolve.err
		
		else
				echo "****DID YOU MAKE YOUR NUISSANCE REGRESSORS (A05)?****"
	fi
done