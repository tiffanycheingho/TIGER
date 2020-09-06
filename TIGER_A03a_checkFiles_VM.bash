#!/bin/bash
#created by SO and TH
#last edited by TH 2018 May

#PURPOSE: Check that all the necessary files exist FOR A SINGLE SUBJECT for preprocessing before moving onto A03b and A04 (the actual preprocessing)

###*VARIABLES THAT NEED TO BE CHECKED****###
timepoint="-T1" #*XXX his needs to be changed according to timepoint
wmerode="1" #XXX this should be decided after running and checking A02 (at the level of a single subject!)
csferode="1" #XXX this should be decided after running and checking A02 (at the level of a single subject!)

copyFiles='1' #if this changes to 0 then the relevant files are NOT copied into the 'Analysis' directory

rootdir="/DATA/TIGER_RSFC_Analysis"
subjdirs="Subjects"
activedir="/DATA/TIGER-T1" 
echo "--------------------------------------------------------------"
echo "**************************************************************"
date
echo "running A03a_checkFiles_VM.bash"
echo "**************************************************************"

for subject in XX; do ###XX is subject ID

	if [ -d ${rootdir}/${subjdirs}/${subject} ] ; then
	
			if [ -f ${rootdir}/${subjdirs}/structs/${subject}_FSt1.nii.gz ] ; then
				echo "${subject} FSt1 exists"
			else
				echo "***${subject} FSt1 does NOT exist!!!***"
				copyFiles='0'
			fi
			
			if [ -f ${rootdir}/${subjdirs}/structs/${subject}_wm_${wmerode}x_erode.nii.gz ] ; then 
				echo "${subject}wm_${wmerode} exists"
			else
				echo "***${subject}wm_${wmerode}x does NOT exist!!!***"
				copyFiles='0'
			fi
			
			if [ -f ${rootdir}/${subjdirs}/structs/${subject}_csf_${csferode}x_erode.nii.gz ] ; then
				echo "${subject} csf_${csferode} exists"
			else
				echo "***${subject}csf_${csferode}x does NOT exist!***"
				copyFiles='0'
			fi
			
			
			if [ -f ${activedir}/${subject}/rest_raw.nii ]; then
				echo "Zipping rest_raw for ${subject}"
				gzip ${rootdir}/${subjdirs}/${subject}/rest_raw.nii
			fi
			
			if [ -f ${activedir}/${subject}/rest_raw.nii.gz ]; then
				echo "${subject} rest_raw.nii.gz exists in active and will be copied to ${subject} Analysis later"	
			else
				echo "***${subject} rest_raw.nii.gz does NOT exist in active!***"
				$copyFiles='0'
			fi
			
			if [ -f ${rootdir}/${subjdirs}/Physio/C_${subject}.1D ] ; then
				echo "${subject} all physio.1D exists"
			 else
				echo "****${subject} PHYSIO.1D MISSING ****"
				copyFiles='0'
			fi
		else
		
		echo "***${subject} FOLDER IN TIGER/RSFC/Analysis DOES NOT EXIST SO SOMETHING IS NOT RIGHT****"
		copyFiles='0'
		
	fi
	
	#echo $copyFiles

		if [ ! -d ${rootdir}/${subjdirs}/${subject}/Analysis ]; then
			echo "**** Making Analysis dir"
			mkdir ${rootdir}/${subjdirs}/${subject}/Analysis
		fi
		
		if [ ${copyFiles} == '1' ] ; then
			
			echo "***we have all files needed and are copying into Analysis to make life easier***"
			cp ${activedir}/${subject}/rest_raw.nii.gz ${rootdir}/${subjdirs}/${subject}/Analysis/rest_raw.nii.gz
			cp ${rootdir}/${subjdirs}/Physio/C_${subject}.1D 	${rootdir}/${subjdirs}/${subject}/Analysis/C_${subject}.1D 
			cp ${rootdir}/${subjdirs}/structs/${subject}_FSt1.nii.gz ${rootdir}/${subjdirs}/${subject}/Analysis/${subject}_FSt1.nii.gz
			cp ${rootdir}/${subjdirs}/structs/${subject}_csf_${csferode}x_erode.nii.gz ${rootdir}/${subjdirs}/${subject}/Analysis/${subject}_csf_${csferode}x_erode.nii.gz
			cp ${rootdir}/${subjdirs}/structs/${subject}_wm_${wmerode}x_erode.nii.gz ${rootdir}/${subjdirs}/${subject}/Analysis/${subject}_wm_${wmerode}x_erode.nii.gz
			cp ${rootdir}/${subjdirs}/structs/MNI152_T1_2mm_brain.nii.gz ${rootdir}/${subjdirs}/${subject}/Analysis/MNI152_T1_2mm_brain.nii.gz
		
			echo "***CONTINUE ONTO A03B****"
		fi
		
		
		if [ ${copyFiles} == '0' ] ; then
			echo "*** DO NOT PROCEED TO A03B AND CHECK FOR YOUR FILES AND/OR MARK IN TRACKER ${subject} UNUSABLE ****"
		fi
		
done
