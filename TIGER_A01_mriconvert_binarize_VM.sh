#!/bin/sh
#created by TH 2017 June
#last edited by TH 2018 May

FREESURFER_HOME="/share/software/freesurfer6.0/" #this technically should already set up in your bash profile: ~/.bashrc
export FREESURFER_HOME=/usr/local/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

output="/DATA/TIGER_RSFC_Analysis/Subjects/structs"
input="/DATA/TIGER_FreeSurfer/TIGER_FS_subjDir"

for x in XX ; do #XX represents subject ID and script assumes this is XX-Timepoint
	fsfldr=$input/${x}/mri

	echo working on $x

	cd ${input}/${x}/
	echo "${input}/${x}/"


	#run mri_convert
	${FREESURFER_HOME}/bin/mri_convert ${fsfldr}/brain.mgz ${output}/${x}_FSt1.nii.gz
	#binarize to create csf mask
	${FREESURFER_HOME}/bin/mri_binarize --i ${fsfldr}/aseg.auto.mgz --ventricles --o ${output}/${x}_csf.nii.gz
	#binarize to create wm mask
	${FREESURFER_HOME}/bin/mri_binarize --i ${fsfldr}/aseg.auto.mgz --wm --o ${output}/${x}_wm.nii.gz

done
 
