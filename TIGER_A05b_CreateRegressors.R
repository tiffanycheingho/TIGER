
##Authors: SO (with edits from TH)
##Last Updated:  2017 July (adapted for mounting on my local machine - sorry!)


##Notes:  Run this *after* doing motion correction A03 scripts (bc need mcplots.1D files)
#               but *before* running nuisance regression (A06_RunNuisanceRegression.bash)


print("*************************************************")
print("************** assuming subject list is in a text file *********************")
print("*************************************************")
#Use A if you want this to happen on all files within a dir
#Use B if you only have a few, specific files you want to process.  Put them in a list:

#A: subDirs <- dir("/Volumes/iang/users/hoTC/TIGER/RSFC/Subjects/")
#B: subDirs <- read.table("/Volumes/iang/users/hoTC/TIGER/RSFC/Subjects/20170109_ListForCreateNuisanceRegressors.txt", stringsAsFactors = FALSE, header = FALSE)

subDirs <- read.table("/DATA/TIGER_RSFC_Analysis/MotionOutliers/Mar_26_2020.txt", stringsAsFactors = FALSE, header = FALSE)
numsub<-dim(subDirs)[1]

print("*************************************************")
print("**************1: mcplots1.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  print(subDirs$V1[s])
  #NOTE HERE THE FILENAME IS mcplots1.1D
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots1.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    y <- x*x
    print(paste("nrow(y)= ", nrow(y)))
    a <- x[2:234,]
    b <- y[2:234,]
    c <- x[1:233,]
    d <- y[1:233,]
    print(paste("length(a)= ", length(a)))
    print(paste("length(b)= ", length(b)))
    print(paste("length(c)= ", length(c)))
    print(paste("length(d)= ", length(d)))
    write.table(a, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots1_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(b, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots1_233sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(c, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots1_233t-1.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(d, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots1_233t-1_sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(y)
    rm(a)
    rm(b)
    rm(c)
    rm(d)
  }
}

print("*************************************************")
print("**************2: mcplots2.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  print(subDirs$V1[s])
  #NOTE HERE THE FILENAME IS mcplots2.1D
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots2.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    y <- x*x
    print(paste("nrow(y)= ", nrow(y)))
    a <- x[2:234,]
    b <- y[2:234,]
    c <- x[1:233,]
    d <- y[1:233,]
    print(paste("length(a)= ", length(a)))
    print(paste("length(b)= ", length(b)))
    print(paste("length(c)= ", length(c)))
    print(paste("length(d)= ", length(d)))
    write.table(a, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots2_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(b, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots2_233sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(c, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots2_233t-1.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(d, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots2_233t-1_sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(y)
    rm(a)
    rm(b)
    rm(c)
    rm(d)
  }
}
print("*************************************************")
print("**************3: mcplots3.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  #print(subDir)
  #NOTE HERE THE FILENAME IS mcplots3.1D
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots3.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    y <- x*x
    print(paste("nrow(y)= ", nrow(y)))
    a <- x[2:234,]
    b <- y[2:234,]
    c <- x[1:233,]
    d <- y[1:233,]
    print(paste("length(a)= ", length(a)))
    print(paste("length(b)= ", length(b)))
    print(paste("length(c)= ", length(c)))
    print(paste("length(d)= ", length(d)))
    write.table(a, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots3_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(b, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots3_233sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(c, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots3_233t-1.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(d, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots3_233t-1_sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(y)
    rm(a)
    rm(b)
    rm(c)
    rm(d)
  }
}
print("*************************************************")
print("**************4: mcplots4.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  #print(subDir)
  #NOTE HERE THE FILENAME IS mcplots4.1D
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots4.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    y <- x*x
    print(paste("nrow(y)= ", nrow(y)))
    a <- x[2:234,]
    b <- y[2:234,]
    c <- x[1:233,]
    d <- y[1:233,]
    print(paste("length(a)= ", length(a)))
    print(paste("length(b)= ", length(b)))
    print(paste("length(c)= ", length(c)))
    print(paste("length(d)= ", length(d)))
    write.table(a, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots4_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(b, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots4_233sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(c, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots4_233t-1.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(d, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots4_233t-1_sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(y)
    rm(a)
    rm(b)
    rm(c)
    rm(d)
  }
}
print("*************************************************")
print("**************5: mcplots5.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
 # print(subDir)
  #NOTE HERE THE FILENAME IS mcplots5.1D
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots5.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    y <- x*x
    print(paste("nrow(y)= ", nrow(y)))
    a <- x[2:234,]
    b <- y[2:234,]
    c <- x[1:233,]
    d <- y[1:233,]
    print(paste("length(a)= ", length(a)))
    print(paste("length(b)= ", length(b)))
    print(paste("length(c)= ", length(c)))
    print(paste("length(d)= ", length(d)))
    write.table(a, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots5_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(b, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots5_233sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(c, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots5_233t-1.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(d, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots5_233t-1_sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(y)
    rm(a)
    rm(b)
    rm(c)
    rm(d)
  }
}
print("*************************************************")
print("**************6: mcplots6.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  #print(subDir)
  #NOTE HERE THE FILENAME IS mcplots1.1D
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/",subDirs$V1[s],"/Analysis/mcplots6.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    y <- x*x
    print(paste("nrow(y)= ", nrow(y)))
    a <- x[2:234,]
    b <- y[2:234,]
    c <- x[1:233,]
    d <- y[1:233,]
    print(paste("length(a)= ", length(a)))
    print(paste("length(b)= ", length(b)))
    print(paste("length(c)= ", length(c)))
    print(paste("length(d)= ", length(d)))
    write.table(a, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots6_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(b, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots6_233sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(c, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots6_233t-1.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    write.table(d, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/mcplots6_233t-1_sq.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(y)
    rm(a)
    rm(b)
    rm(c)
    rm(d)
  }
}


print("*************************************************")
print("**************7: XXX_csf.1D*********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  #print(subDir)
  #NOTE HERE THE FILENAME IS XXX_csf.1D 
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/", subDirs$V1[s], "_csf.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    x <- read.delim(fileName, header=FALSE)
    print(paste("nrow(x) =", nrow(x)))
    e <- x[2:234,]
    print(paste("length(e)= ", length(e)))
    write.table(e, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/", subDirs$V1[s], "_csf_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(x)
    rm(e)
  }
}
print("*************************************************")
print("**************8: XXX_wm.1D***********************")
print("*************************************************")

for(s in 1:numsub){
  print("****************************")
  #print(subDir)
  #NOTE HERE THE FILENAME IS XXX_wm.1D 
  fileName <- paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/", subDirs$V1[s], "_wm.1D")
  cat(fileName,"\n")
  print(file.exists(fileName))
  if (file.exists(fileName)){
    print(fileName)
    y <- read.delim(fileName, header=FALSE)
    print(paste("nrow(y) =", nrow(y)))
    f <- y[2:234,]
    print(paste("length(f)= ", length(f)))
    write.table(f, file = paste0("/DATA/TIGER_RSFC_Analysis/Subjects/", subDirs$V1[s], "/Analysis/", subDirs$V1[s], "_wm_233.1D"),  append=FALSE, row.names=FALSE, col.names=FALSE)
    rm(y)
    rm(f)
  }
}


