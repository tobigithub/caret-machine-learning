# Run simple cross-validation method with caret and knn
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# All caret cross-validation methods applied using lapply (list result) 
# regression example using knn (very fast); "none" is not allowed for lapply

  require(caret); data(BloodBrain); 
  cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot");
  all <- lapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
                    fit1 <- train(bbbDescr, logBBB, trControl=tc, method="knn") })  
  all
  
  # just to show the structure of output
  # sapply(all,getTrainPerf)
  # lapply(all,getTrainPerf)
  
  # extract the used cvMethods (redundant because already incvMethods) 
  myNames <- lapply(1:6, function(x) all[[x]]$control$method)
  # save results
  results <- sapply(all,getTrainPerf)
  # change column Names to cv methods
   colnames(results) <- myNames; results
  # get the results
  results
 
#---------------------------------------------------------------------------

# All cross-validation methods applied using sapply (matrix result)
# regression example using knn (very fast); "none" is not allowed for lapply

  require(caret); data(BloodBrain); 
  cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot" );
  all <- sapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
                    fit1 <- train(bbbDescr, logBBB, trControl=tc, method="knn") }); all 
  all[4, ]
  
  ### END
