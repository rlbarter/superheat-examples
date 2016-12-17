# This script contains code to use CV to select the regularization parameter for lasso.

selectLambda <- function(cl, x.mat, y.mat, features, lambda.seq) {
  # Arguments:
  #   cl: the cluster
  #   x.mat: the feature matrix (col = Gabor feature, row = image)
  #   y.mat: the matrix of response vectors (col = voxel, row = image)
  #   featuresL a list of feature indices for each voxel
  #   lambda.seq: a list containing the fixed sequence of lambda values for each voxel
  # Returns
  #   lambda.select: a vector detailing the best lambda value for each voxel
  
  # Generate a list of CV indices
  clusterExport(cl, c("x.mat", "y.mat", "features"), envir=environment()) 
  # loop through 
  #   1. voxels (parallelize)
  #   2. cv folds
  lasso.voxel.list <- parLapply(cl, 1:ncol(y.mat), function(voxel) {
    # extract the responses for the current voxel
    voxel.resp <- y.mat[, voxel]
    # extract the feature matrix for the current voxel
    voxel.feat <- x.mat[, features[[voxel]]]
    # extract the lambda sequence for the current voxel
    lambda <- lambda.seq[[voxel]]
    # loop through the CV folds
    # apply the lasso model for each value of the lambda/tau 
    # fit on the cv training set
    cv.glmnet(x = voxel.feat, y = voxel.resp, 
              lambda = lambda, nfolds = 10)
  })

  # extract best lambda based on CV for each voxel
  lambda.select <- sapply(lasso.voxel.list, function(lasso.obj) {
      lambda = lasso.obj$lambda.1se
      return(lambda)
    })
  
  return(lambda.select)
}
