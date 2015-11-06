# Run all cross-validations with method with qrf (Quantile Random Forest)
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)


# load libs
require(caret); data(BloodBrain); 

# register parallel client
library(doParallel); cl <- makeCluster(detectCores()); registerDoParallel(cl) 

# define all cross-validation methods
cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot");

# use R lapply function to loop through all CV methos with qrf
all <- lapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
              fit1 <- train(bbbDescr, logBBB, trControl=tc, method="qrf") }); all;

# extract the used cvMethods (redundant because already incvMethods) 
myNames <- lapply(1:6, function(x) all[[x]]$control$method)

# save results
results <- sapply(all,getTrainPerf)

# change column Names to cv methods
colnames(results) <- myNames; 

# get the results
results

# stop cluster
stopCluster(cl); registerDoSEQ();

#               boot632   LGOCV     LOOCV     cv        repeatedcv boot     
# TrainRMSE     0.4199394 0.5450903 0.5264716 0.5210002 0.5127061  0.5539934
# TrainRsquared 0.6829296 0.5193978 0.5474211 0.561647  0.5776622  0.5350395
# method        "qrf"     "qrf"     "qrf"     "qrf"     "qrf"      "qrf"    
