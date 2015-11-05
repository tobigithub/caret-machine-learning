# Run simple cross-validation method with caret and knn
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# Single example, no cross-validation
  require(caret); data(BloodBrain); set.seed(123);
  fit1 <- train(bbbDescr, logBBB, "knn"); fit1

# cross-validation example with method boot 
  require(caret); data(BloodBrain); set.seed(123);
  tc <- trainControl(method="boot")
  fit1 <- train(bbbDescr, logBBB, trControl=tc, method="knn");  fit1
  
# All available six cross-validation methods applied  
  require(caret); data(BloodBrain); 
  cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot" );
  all <- sapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
                    fit1 <- train(bbbDescr, logBBB, trControl=tc, method="knn") }); all 
  all[4, ]

  
### END
