library(glmnet)
library(ggplot2)
library(parallel)

nCores <- 24  # to set manually 
cl <- makeCluster(nCores) 

# load the training data
load("fmri_training_data.RData")
# load the CV parameter selection function
source("select_lambda.R")


# identify the 500 most correlated features for each variable
load("voxel_cor.RData")
top.features <- lapply(cor.vox, function(cor) {
  order(cor, decreasing = TRUE)[1:500]
})

# fit the lasso model to each voxel using the 1000 most correlated features
# for the voxel.
clusterExport(cl, c("train.feat", "train.resp", "glmnet", "top.features"), 
              envir=environment()) 
lasso.list <- parLapply(cl, 1:ncol(train.resp), function(voxel) {
  glmnet(x = train.feat[, top.features[[voxel]]], 
         y = as.vector(train.resp[ , voxel])) 
})
# extract the lambda sequence from each voxel
# we want to avoid the ends of the sequence
# note that some sequences terminate early so providing a universal endpoint for 
# the vector sometimes produces an error
lambda.seq <- lapply(lasso.list, function(model) model$lambda[5:length(model$lambda)])

# use CV to select the best lambda for each voxel-model
# export the necessary variables
clusterExport(cl, c("train.feat", 
                    "train.resp", "top.features", 
                    "cv.glmnet", "lambda.seq"), 
              envir=environment()) 
# the ith entry of selected.lambda corresponds to the best lambda value for voxel i
selected.lambda <- selectLambda(cl = cl, x.mat = train.feat, 
                       y.mat = train.resp, features = top.features, 
                       lambda.seq = lambda.seq)

# save the results
save(lasso.list, selected.lambda, top.features, file = "../results/lasso_results_top500.RData")


stopCluster(cl)
