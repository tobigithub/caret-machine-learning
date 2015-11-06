# load libs
require(caret); data(BloodBrain); 

# register parallel client
library(doParallel); cl <- makeCluster(detectCores()); registerDoParallel(cl) 

# define all cross-validation methods
cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot");

# use R lapply function to loop through all CV methos with qrf
all <- lapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
              fit1 <- train(bbbDescr, logBBB, trControl=tc, method="cubist") }); all;

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

### END
