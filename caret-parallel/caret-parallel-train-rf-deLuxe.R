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
