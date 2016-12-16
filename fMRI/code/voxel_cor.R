library(parallel)

nCores <- 3  # to set manually 
cl <- makeCluster(nCores) 

# load the training data
load("fmri_training_data.RData")

# export the necessary variables
clusterExport(cl, c("train.feat", "train.resp", "glmnet"), 
              envir=environment()) 
# calcualte the correlation of each variable with each voxel
system.time(
  cor.vox <- parLapply(cl, data.frame(train.resp), function(voxel) {
    apply(train.feat, 2, function(feature) cor(voxel, feature))
  })
)

save(cor.vox, file = "../results/voxel_cor.RData")