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


# All cross-validation methods applied using sapply (matrix result)
# regression example using knn (very fast); "none" is not allowed for lapply

  require(caret); data(BloodBrain); 
  cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot" );
  all <- sapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
                    fit1 <- train(bbbDescr, logBBB, trControl=tc, method="knn") }); all 
  all[4, ]
  
  ### END
