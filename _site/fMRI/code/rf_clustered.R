library(randomForest)
library(parallel)

nCores <- 20  # to set manually 
cl <- makeCluster(nCores) 

# load the training data
load("fmri_training_data.RData")
load("voxel_cor.RData")
load("voxel_clusters.RData")

# identify the 500 most correlated features for each variable
top.features <- lapply(cor.vox, function(cor) {
  order(cor, decreasing = TRUE)[1:500]
})
# Split the training dataset into the two cluster groups
train.resp.cl1 <- train.resp[ , voxel.clusters == 1]
train.resp.cl2 <- train.resp[ , voxel.clusters == 2]
# Split the voxel-specific feature selections into cluster groups
top.features.cl1 <- top.features[voxel.clusters == 1]
top.features.cl2 <- top.features[voxel.clusters == 2]

# run random forest for each of the voxel lists
clusterExport(cl, c("train.resp.cl1", "train.resp.cl2", "train.feat", "randomForest",
		    "top.features.cl1", "top.features.cl2"), 
              envir=environment()) 
system.time(
  rf.predictions.cl1 <- parLapply(cl, 1:ncol(train.resp.cl1), function(voxel) {
    randomForest(x = train.feat[, top.features.cl1[[voxel]]], 
		 y = train.resp.cl1[, voxel], 
		 ntree = 100)
  })
)
system.time(
  rf.predictions.cl2 <- parLapply(cl, 1:ncol(train.resp.cl2), function(voxel) {
    randomForest(x = train.feat[, top.features.cl2[[voxel]]], 
                 y = train.resp.cl2[, voxel], 
                 ntree = 100)
  })
)

save(rf.predictions.cl1, rf.predictions.cl2, file = "rf_cluster_results_top500.RData")
