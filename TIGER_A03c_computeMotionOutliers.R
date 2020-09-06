##File:   "TIGER_A03c_computeMotionOutliers.R"
##Authors: Sarah Ordaz and Tiffany Ho
##Updates: Last Updated by TH 2018 February
##Usage: Run this AFTER you run Tiger_A03b_PreprocessFunc_SingleSubj_VM.bash as this script will use its outputs
##Output:
#The first is a textfile called XXX_mcplotsRelMean in MotionOutliers which incidates if the overall mean relative mean displacement exceeds 0.2 mm ("1" indicates yes they do and need to be rescanned/omitted and "0" indicates all good)
#The second is a textfile called XXX_mcplotsRel in MotionOutliers which indicates the # of volumes where MRD > 0.25; a bad participant > 20 volumes with mean relative displacement > 0.25 mm 
#a bad subject is one that meets either of these criteria
#the third is a textfile in the subject's Analysis directoty that indicates for each TR whether MRD > 0.25mm (1=yes 0=no)

#the variable date will be used for naming the resulting text files/csv files
date="20200326" #XXX change this

#setwd("/DATA/TIGER_RSFC_Analysis/TIGER_RSFC_Analysis/scripts")
print(getwd())
print("A03b_computeMotionOutliers.R is running")


#XXX change the text file name below which should contain a list of subjects in the format XXX-Timepoint
subDirs <- read.table("/DATA/TIGER_RSFC_Analysis/MotionOutliers/Mar_26_2020.txt", stringsAsFactors = FALSE, header = FALSE)
numsub<-dim(subDirs)[1]

#Create empty data frame with three columns (fname, RelMean, Gt0.2) with filenames, "NA", and 1 (respectively).
#Fill 1st col of data frame with file name
#Fill 2nd col of data frame with mean rel rms or rel rms
mcplotsRelMeanList <- data.frame(fname=rep(NA, numsub), RelMean=rep(NA_integer_, numsub), Gt0.2=rep(1, numsub))
mcplotsRelList <- data.frame(fname=rep(NA, numsub))

for(s in 1:numsub){
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots_rel_mean.rms")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
  #  print(fileName)   
  #  print(s)
    mcplotsRelMeanList$fname[s] <- fileName
    mcplotsRelMeanList$RelMean[s] <- read.csv(fileName, header=FALSE)
	
  }
	#Fill 1st col of data frame with file name
	#Fill 2nd col of data frame with  rel rms
	fileName2 <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots_rel.rms")
	cat(fileName2,"\n")
	print(file.exists(fileName2))
  if (file.exists(fileName2)){
  #  print(fileName2)   
   # print(s)
    mcplotsRelList$fname[s] <- fileName2
  }
}

#Re-evaluate 3rd col values.  If (col 2) mean rel rms is le 0.2, replace 1 with a 0
  #temp <- read.csv(mcplotsRelMeanList[i], header=FALSE)
  #mcplotsRelMeanList2$RelMean[i] <- temp$V1
for(s in 1:numsub){
  if (mcplotsRelMeanList$RelMean[s] <= 0.2){
  	mcplotsRelMeanList$Gt0.2[s] <- 0
  }
}

mcplotsRelMeanList$RelMean <- as.numeric(mcplotsRelMeanList$RelMean)  #If I don't do this, the format of the df is that it contains a list rather than numerics or characters
write.table(mcplotsRelMeanList, file=paste("/DATA/TIGER_RSFC_Analysis/MotionOutliers/", date, "_mcplotsRelMean.txt", sep=""), append=FALSE, row.names=FALSE, col.names=TRUE)

#Create file to summarize all subjs with two columns (relFname, numColsGt.25)
mcplotsRelList2 <- data.frame(relFname=mcplotsRelList, numColsGt.25=rep(NA_integer_, numsub))


#For EACH subject:
#(1) Import data into a data frame (TRs) and rename columns
#(2) Put a 0 or 1 in 2nd col, based on amount of relative motion (Gt 0.25mm)
#(3) Save that data fram (subjFile) as a .txt file
#(4) Calculate the sum of 2nd col, and put this in mcplotsRelList2
for(s in 1:length(mcplotsRelList$fname)){
  subjFile <- read.table(mcplotsRelList$fname[s], header=FALSE)
  subjFile$Gt.25 <- 1
  names(subjFile) <- c("RelMotion", "Gt.25")
  for(j in 1:nrow(subjFile)){
    if(subjFile$RelMotion[j] <=0.25) subjFile$Gt.25[j] <- 0
  }
  print(subjFile)
  write.table(subjFile, file=paste(mcplotsRelList$fname[s], "_wExtra.txt", sep=""), append=FALSE, row.names=FALSE, col.names=TRUE)
  sum <- sum(subjFile$Gt.25) 
  print(sum)
  mcplotsRelList2$numColsGt.25[s] <- sum  
}
print(mcplotsRelList2)

#Put summary data into a summary spreadsheet
write.table(mcplotsRelList2, file=paste("/DATA/TIGER_RSFC_Analysis/MotionOutliers/", date, "_mcplotsRel.txt", sep=""), append=FALSE, row.names=FALSE, col.names=TRUE)

#Save workspace
#save.image(paste("/DATA/TIGER_RSFC_Analysis/TIGER_RSFC_Analysis/scripts/MotionOutliers", date, "A03c_computeMotionOutliers_workspace.Rdata", sep=""))
