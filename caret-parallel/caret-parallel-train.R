# Run multiple caret models in parallel using lapply
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# -------------------------------------------------------------------------
# FIRST sequential code (not parallel one CPU core):
# ------------------------------------------------------------------------- 

require(caret); data(BloodBrain); set.seed(123)
fit1 <- train(bbbDescr, logBBB, "knn"); fit1

# ------------------------------------------------------------------------- 
# SECOND parallel register 4 cores (no worries if you only have 2)
# train the caret model in parallel 
# -------------------------------------------------------------------------

library(doParallel); cl <- makeCluster(4); registerDoParallel(cl) 
  require(caret); data(BloodBrain); set.seed(123)
  fit1 <- train(bbbDescr, logBBB, "knn"); fit1
stopCluster(cl); registerDoSEQ();

### END
