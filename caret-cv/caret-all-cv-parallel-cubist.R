# Run all cross-validations with method with cubist 
# Read: http://rulequest.com/cubist-examples.html
# Read: https://cran.r-project.org/web/packages/Cubist/vignettes/cubist.pdf
# Read: http://www.r-bloggers.com/ensemble-learning-with-cubist-model/
#
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

#               boot632   LGOCV     LOOCV     cv        repeatedcv boot     
# TrainRMSE     0.3794002 0.4959378 0.4997026 0.4933169 0.4930747  0.5617455
# TrainRsquared 0.6743715 0.6067721 0.5875271 0.603017  0.6032699  0.4883528
# method        "cubist"  "cubist"  "cubist"  "cubist"  "cubist"   "cubist" 


### END
