#!/bin/bash
#last edited by TH 2018 May

# Erode white matter and csf at differing amounts

export FREESURFER_HOME=/usr/local/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

export SUBJECTS_DIR="/DATA/TIGER_RSFC_Analysis/Subjects/structs"

for subj in XX; do #XX is ID

dilate_amounts=( 1 2 3 ) # you can also try eroding by 4 voxels but for our data it was clearly overkill
for i in "${dilate_amounts[@]}"

do
	csf=$SUBJECTS_DIR/${subj}"_csf.nii.gz"
	wm=$SUBJECTS_DIR/${subj}"_wm.nii.gz"
	csf_erode=$SUBJECTS_DIR/${subj}"_csf_"${i}"x_erode.nii.gz"
	wm_erode=$SUBJECTS_DIR/${subj}"_wm_"${i}"x_erode.nii.gz"

#run mri_binarize
	${FREESURFER_HOME}/bin/mri_binarize --i $csf --erode ${i} --o $csf_erode --min 1 --max 1000
	${FREESURFER_HOME}/bin/mri_binarize --i $wm --erode ${i} --o $wm_erode --min 1 --max 1000
	echo ${subj} csf and wm eroded at ${i}x!


done
done
 
