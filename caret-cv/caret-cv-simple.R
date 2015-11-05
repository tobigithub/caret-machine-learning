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
  

### END
