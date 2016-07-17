# Run random forest in parallel with CPU core and thread info
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

require(caret)
data(BloodBrain)
set.seed(123)

# Library parallel() is a native R library, no CRAN required
library(parallel)
nCores <- detectCores(logical = FALSE)
nThreads <- detectCores(logical = TRUE)
cat("CPU with",nCores,"cores and",nThreads,"threads detected.\n")

# load the doParallel/doSNOW library for caret cluster use
library(doParallel)
cl <- makeCluster(nThreads)
registerDoParallel(cl)

# random forest regression
fit1 <- train(bbbDescr, logBBB, "rf")
fit1; 


stopCluster(cl)
registerDoSEQ()
### END

# 208 samples
# 134 predictors
# 
# No pre-processing
# Resampling: Bootstrapped (25 reps) 
# Summary of sample sizes: 208, 208, 208, 208, 208, 208, ... 
# Resampling results across tuning parameters:
# 
#   mtry  RMSE       Rsquared 
#     2   0.5443770  0.5725600
#    68   0.5408819  0.5568365
#   134   0.5490382  0.5413179
# 
# RMSE was used to select the optimal model using  the smallest value.
# The final value used for the model was mtry = 68. 
