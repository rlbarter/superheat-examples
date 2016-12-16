# fMRI Superheat Example

This folder contains the analysis for the fMRI superheat example. 

## Data

The initial data files found from the CRNS website (https://crcns.org/data-sets/vc/vim-1) are

* raw_data/EstimatedResponses.mat: the BOLD voxel responses

* raw_data/Stimuli.mat: the raw images

Unfortunately, the gabor wavelet features were not available, but we have obtained them separately. They are contained in the file

* processed_data/fMRIdata.RData

## Scripts

### Converting EstimatedResponses.mat into a readable format

There are a number of scripts that are used to analyze this data. First, the EstimatedResponses.mat file was the wrong version of MATLAB file and could not be read into R. Thus, this was converted to a V6 R-readable MATLAB file using the following commands in Oracle:

>> dat = load("EstimatedResponses.mat")
>> save("-V6", "EstimatedResponsesV6.mat", "dat")

### The report

The file 

* fMRI.Rmd 

contains a description of the general analysis procedure.

It also produces the cleaned data files that are contained in 

* processed_data/fmri_training_data.RData

The modelling code is presented in the markdown file, but was not run in the markdown compilation as it was very computationally intensive.

### The modelling

The model files were run on the SCF high priority cluster using 24 cores.

* code/voxel_cor.R: a file for identifying the 1000 most correlated features with each voxel. Produces voxel_cor.RData

* code/select_lambda.R: a function for choosing the lasso regularization parameter using CV. Called in lasso.R

* code/lasso.R: a file containing code for running the lasso models. 

* code/rf.R a file containig code for running the Random Forest models.

## Results

The results from the lasso model when not a-priori selecting correlated features is contained in

* results/lasso_full_results.RData

For the remainder of the results, we first filter to the 500 most
correlated features with each voxel. This correlation between each
voxel and each feature is contained in

* results/voxel_cor.RData

and the codeto produce this file is contained in the voxel_cor.R file.

The lasso and RF results for the 500 most correlated features with
each voxel are contained in

* results/lasso_results_top500.RData

* results/rf_results_top500.RData
