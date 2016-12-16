library(randomForest)
library(parallel)

nCores <- 24  # to set manually 
cl <- makeCluster(nCores) 

# load the training data
load("processed_data/fmri_training_data.RData")
load("processed_data/voxel_cor.RData")


# identify the 500 most correlated features for each variable
top.features <- lapply(cor.vox, function(cor) {
  order(cor, decreasing = TRUE)[1:500]
})
# define a feature matrix for each voxel
#train.vox.list <- lapply(1:ncol(train.resp), function(voxel) {
#  training.mat <- train.feat[ ,top.features[[voxel]]]
#  colnames(training.mat) <- paste0("x", 1:ncol(training.mat))
#  cbind(y = train.resp[, voxel], training.mat)
#})
# run random forest for each of the voxel lists
clusterExport(cl, c("train.resp", "train.feat", "randomForest",
		    "top.features"), 
              envir=environment()) 
system.time(
  rf.predictions <- parLapply(cl, 1:ncol(train.resp), function(voxel) {
    randomForest(x = train.feat[, top.features[[voxel]]], 
		 y = train.resp[, voxel], 
		 ntree = 100)
  })
)

save(rf.predictions, file = "../results/rf_results_top500.RData")
