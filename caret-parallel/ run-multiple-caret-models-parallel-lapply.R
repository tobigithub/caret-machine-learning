# Run multiple caret models in parallel using lapply
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)


require(caret); data(BloodBrain); m <- c("qrf","xgbTree","knn","rf");
library(doParallel); cl <- makeCluster(8); registerDoParallel(cl)
require(caret); data(BloodBrain); m <- c("qrf","xgbTree","rknn","knn","rf");
t2 <- lapply(m,function(x) {set.seed(123); seeds <- vector(mode = "list", length = nrow(bbbDescr) + 1); seeds <- lapply(seeds, function(x) 1:20); t1 <- train(bbbDescr, logBBB, (x),trControl = trainControl(method = "cv",seeds=seeds))})
r2 <- lapply(1:length(t2), function(x) {cat(sprintf("%-10s",(m[x])));cat(t2[[x]]$results$Rsquared[which.min(t2[[x]]$results$RMSE)],"\t"); cat(t2[[x]]$results$RMSE[which.min(t2[[x]]$results$RMSE)],"\n")})
stopCluster(cl); registerDoSEQ();

#model     R^2           RMSE
#qrf       0.5861108     0.5120318 
#xgbTree   0.6129255     0.4858211 
#rknn      0.4351047     0.5941893 
#knn       0.3736528     0.6185242 
#rf        0.6037442     0.493395 
