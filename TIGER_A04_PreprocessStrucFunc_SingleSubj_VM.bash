#!/bin/bash

#Authors: SO and TH
#Last Update: TH 2018 February


###*VARIABLES THAT NEED TO BE CHECKED****###
timepoint="-T1" #*XXX his needs to be changed according to timepoint
wmerode="1" #XXX this should be decided after running and checking A02 ("2" is usually what we choose)
csferode="1" #XXX this should be decided after running and checking A02 ("1" is usually what we choose)


rootdir="/DATA/TIGER_RSFC_Analysis/"
subjdirs="Subjects"
activedir="/DATA/TIGER-T2"
echo "**************************************************************"
date
echo "running A04_PreprocessStrucFunc_SingleSubj_VM.bash"
echo "**************************************************************"

for subject in  XX; do ###XXX THIS IS WHERE SUBJECT ID SHOULD BE INPUTTED

	if [ -d ${rootdir}/${subjdirs}/${subject}/Analysis ] && [ -e ${rootdir}/${subjdirs}/${subject}/Analysis/rest_raw_rdptkm.nii.gz ] ; then 
		
	echo "***RUNNING PREPROCESSING IN ${SUBJECT} Analysis***"
			#################################################################
			##### The rest of the script is run from the Analysis dir
			#################################################################
			cd ${rootdir}/${subjdirs}/${subject}/Analysis
			
						
			
			#################################################################
			##### Register/Normalize/Align func and struct to a template (MNI 2mm)
			#################################################################
		
			echo "*********** a: alignment/registration of func --> struc --> MNI 2 mm"
			echo "NOTE! After this step, functionals move from RAI to RPI"
			
			echo ------------------------------
			echo PROCESSING ANATOMICAL SCANS!!
			echo ------------------------------
			
			3dresample -orient RPI -inset ${subject}_FSt1.nii.gz -prefix ${subject}_FSt1_RPI.nii.gz  #RPI 256x256x256  #This is equivalent to _brain above
			
			## FUNC->T1
			echo ------------------------------
			echo !!!! FUNC1 to STRUCT !!!!
			echo ------------------------------

			flirt -ref ${subject}_FSt1_RPI.nii.gz -in rest_raw_rdptkm.nii.gz -dof 7 -omat ${subject}func1tostruct.mat -v
			
			## Create mat file for conversion from subject's anatomical to functional
			convert_xfm -inverse -omat ${subject}structtofunc1.mat ${subject}func1tostruct.mat -v
			
			
			## T1->STANDARD
			echo ------------------------------
			echo !!!! STRUCT to MNI !!!!
			echo ------------------------------
			## registration of betted struct to MNI space (also betted) and generation of affine transform
			## RPI = ${FSLDIR}/data/standard/MNI152_T1_2mm_brain
			
			flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -in ${subject}_FSt1_RPI.nii.gz -omat ${subject}lin_structtostandard.mat -out ${subject}struct_to_mni.nii.gz -v  
			

			## FUNC->STANDARD
			echo ------------------------------
			echo !!!! FUNC1 to MNI via STRUCT !!!!
			echo ------------------------------
			## Create mat file for registration of functional to standard
			convert_xfm -omat ${subject}lin_func1tostandard.mat -concat ${subject}lin_structtostandard.mat ${subject}func1tostruct.mat -v
			
			## RPI: output file: rest_raw_rdptkma.nii.gz 			flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz \
			 -in rest_raw_rdptkm.nii.gz \
			 -dof 7 \
			 -out rest_raw_rdptkma.nii.gz \
			 -applyxfm -init ${subject}lin_func1tostandard.mat
			
			
			echo "*********** Resampling, normalizing/registering, and extracting ${subjdir} tissue-based regressors" 

			# Resample wm and csf masks
			3dresample -orient RPI -inset ${subject}_wm_${wmerode}x_erode.nii.gz -prefix ${subject}_wm_${wmerode}x_erode_RPI.nii.gz
			## Apply transformation coefficients rather than align to a reference brain because the latter doesn't provide enough information and you get *crazy* results - esp bad for csf

			flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz \
			 -in ${subject}_wm_${wmerode}x_erode_RPI.nii.gz \
			 -out ${subject}_wm_${wmerode}x_erode_RPI_to_mni.nii.gz \
			 -applyxfm -init ${subject}lin_structtostandard.mat
			
			3dresample -orient RPI -inset ${subject}_csf_${csferode}x_erode.nii.gz -prefix ${subject}_csf_${csferode}x_erode_RPI.nii.gz
			
			flirt -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz \
			 -in ${subject}_csf_${csferode}x_erode_RPI.nii.gz \
			 -out ${subject}_csf_${csferode}x_erode_RPI_to_mni.nii.gz \
			 -applyxfm -init ${subject}lin_structtostandard.mat
			
			
			# Extract signal for csf and wm
			echo "Extracting ${subjdir} tissue-based regressors"
			echo "!! This must be done before spatially smoothing as per Jo, H.J. Journal of Applied Mathematics 2013 !!"
				
			## csf
			echo "Extracting signal from csf"
			3dmaskave -mask ${subject}_csf_${csferode}x_erode_RPI_to_mni.nii.gz -quiet rest_raw_rdptkma.nii.gz > ${subject}_csf.1D
			
			## wm
			echo "Extracting signal from white matter"
			3dmaskave -mask ${subject}_wm_${wmerode}x_erode_RPI_to_mni.nii.gz -quiet rest_raw_rdptkma.nii.gz > ${subject}_wm.1D
			
		
			#################################################################
			##### Spatially smooth
			#################################################################
			echo "*********** s: Smoothing ${subjdir}"
			#NOTE: Important to do this *after* extracting wm and csf signal because you don't want to have blurred non-wm/csf data into the csf and wm mask (Hallquist 2013 NeuroImage)
			
			3dBlurInMask -input rest_raw_rdptkma.nii.gz -FWHM 5 -automask -prefix rest_raw_rdptkmas.nii.gz 
	
	else
		
		echo "***DID YOU RUN THE A03 SCRIPTS? SOMETHING ISN'T RIGHT!!!***"
	
	fi
	
done