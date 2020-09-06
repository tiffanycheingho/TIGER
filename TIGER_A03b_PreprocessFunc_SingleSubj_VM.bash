#!/bin/bash

#Authors: 	SO and TH
#Last edited by TH 2018 February

###*VARIABLES THAT NEED TO BE CHECKED****###
timepoint="-T1" #*XXX this needs to be changed according to timepoint

rootdir="/DATA/TIGER_RSFC_Analysis/"
subjdirs="Subjects"
activedir="/DATA/TIGER-T1" 
echo "**************************************************************"
date
echo "running A03b_PreprocessFunc_SingleSubj_VM.bash"
echo "**************************************************************"

for subject in XX; do ###XXX THIS IS WHERE SUBJECT ID SHOULD BE INPUTTED

	if [ -d ${rootdir}/${subjdirs}/${subject}/Analysis ] ; then 
		
	echo "***RUNNING PREPROCESSING IN ${SUBJECT} Analysis***"
			#################################################################
			##### The rest of the script is run from the Analysis dir
			#################################################################
			cd ${rootdir}/${subjdirs}/${subject}/Analysis
			
			#################################################################
			##### Remove first 6 volumes/TRs
			#################################################################
			echo "*********** r: Removing first 6 TRs"
			3dcalc -a 'rest_raw.nii.gz[6..$]' -expr 'a' -prefix rest_raw_r.nii.gz #NOTE: TIGER HAS 240 but ELS has 180 volumes
			
			
			#################################################################
			##### 3dDespike
			#################################################################
			echo "*********** d: Running 3dDespike"
			3dDespike -nomask -prefix rest_raw_rd.nii.gz rest_raw_r.nii.gz 
			echo "#TODO: Fix this for people with spike noise problem"
			
			
			#################################################################
			##### Physiocorrection
			#################################################################
			#NOTE: Run this before slice timing correction

			echo "*********** p: Running physio correction"
	
			timing_tool.py -timing C_${subject}.1D -timing_to_1D rwave.1D -tr 0.025 -stim_dur 0.001 -min_frac 0.01 -run_len 468
			#if error doing physio it could be due to length of the output of this file and due to some "duplicate" value
			
			# (7) Run retroicor 
			# This is cardiac only (no resp).  Not worth it to include resp.
			3dretroicor -prefix rest_raw_rdp.nii.gz -threshold 0.5 -card rwave.1D -order 2 rest_raw_rd.nii.gz 

			
			#################################################################
			##### Slice-timing correction
			#################################################################
			# Per Poldrack's advice, could delete this as this is more important for event-related designs
			# Lucas is ascending, CNI is interleaved - all TIGER data collected at CNI
			echo "*********** t: Running slice-timing correction"
			echo "Confirm order of motion correction and slice time correction!"
			fsl5.0-slicetimer -i rest_raw_rdp.nii.gz -o rest_raw_rdpt.nii.gz --odd -r `fsl5.0-fslval rest_raw_rdp pixdim4`
		
			
			#################################################################
			##### Remove skull/edge detect
			#################################################################
			#NOTE: This does not use the t1 from above, but should be fine.  
			echo "*********** k: Skull-stripping functional"
			# 1. Create mean functional
			fsl5.0-fslmaths rest_raw_rdpt.nii.gz -Tmean rest_raw_rdpt_meanfunc.nii.gz
			# 2. This skull strips functional and creates two output files: (a) a skull-stripped mean functional file (1TR) and a (b) mask
			fsl5.0-bet rest_raw_rdpt_meanfunc.nii.gz rest_raw_rdptk_meanfunc.nii.gz -R -f 0.40 -m #MHallquist uses 0.4 as default
			# 3. Use the mask generated from skull stripping the mean functional to strip all functionals
			fsl5.0-fslmaths rest_raw_rdpt.nii.gz -mas rest_raw_rdptk_meanfunc_mask.nii.gz rest_raw_rdptk.nii.gz

			#****** Bad alternate option: Do not use 3dAutomask, as mcchen had done!
	
			#################################################################
			##### Motion correction
			#################################################################

			echo "*********** m: Running motion correction"

			fsl5.0-mcflirt -in rest_raw_rdptk.nii.gz -out mcplots -mats -plots -refvol 117 -rmsrel -rmsabs
			mv mcplots.nii.gz rest_raw_rdptkm.nii.gz
			
			fsl5.0-fsl_tsplot -i mcplots.par -t 'MCFLIRT estimated rotations (radians)' -u 1 --start=1 --finish=3 -a x,y,z -w 1000 -h 400 -o rot.png
			fsl5.0-fsl_tsplot -i mcplots.par -t 'MCFLIRT estimated translations (mm)' -u 1 --start=4 --finish=6 -a x,y,z -w 1000 -h 400 -o trans.png
			fsl5.0-fsl_tsplot -i mcplots_abs.rms,mcplots_rel.rms -t 'MCFLIRT estimated mean displacement (mm)' -u 1 -w 1000 -h 400 -a absolute,relative -o disp.png
			
			echo "!!!!!!!! When done running script, need to run A03b_MotionOutliers.R !!!!!!!!!"
			echo "!! Output of that script will be in MotionOutliers dir !!"
			#mcplots_rel_mean.rms - Must be < 0.2 mm.  SBergman is using 0.3 mm
			#mcplots_rel.rms      - No >20 volumes with MRD > 0.25 mm
			#UNLIKELY, BUT IF I HAVE HRS OF SPARE TIME: SBergman also uses tSNR, which she pulls from qa_report.png which is in the original rest_32mm_... dir in ELS (biac4/gotlib/biac3/gotlib7/data/ELS/ELS-T1/001-T1/functional/rest/rest_32mm_2sec/qa_report.png).  
			#	Higher is better and 65 and 70 is good; she's using <60
			
	else
	
	echo "***YOU DIDN'T RUN A03A DID YOU? SOMETHING ISN'T RIGHT!!!***"
	
	fi
	
done