# Run multiple caret models in parallel using sapply
# See: http://stackoverflow.com/questions/3505701/r-grouping-functions-sapply-vs-lapply-vs-apply-vs-tapply-vs-by-vs-aggrega
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

require(caret); data(BloodBrain); m <- c("qrf","xgbTree","knn")
library(doParallel); cl <- makeCluster(12); registerDoParallel(cl)
sapply(m,function(x) {t1 <- train(bbbDescr, logBBB, (x))} ,USE.NAMES = TRUE)
class(t2); t2; t2[4,]; stopCluster(cl); registerDoSEQ();

#             qrf          xgbTree      knn         
#method       "qrf"        "xgbTree"    "knn"       
#modelInfo    List,11      List,14      List,13     
#modelType    "Regression" "Regression" "Regression"
#results      List,5       List,7       List,5      
#pred         NULL         NULL         NULL        
#bestTune     List,1       List,3       List,1      
#call         Expression   Expression   Expression  
#dots         List,0       List,0       List,0      
#metric       "RMSE"       "RMSE"       "RMSE"      
#control      List,26      List,26      List,26     
#finalModel   List,23      List,6       List,7      
#preProcess   NULL         NULL         NULL        
#trainingData List,135     List,135     List,135    
#resample     List,3       List,3       List,3      
#resampledCM  NULL         NULL         NULL        
#perfNames    Character,2  Character,2  Character,2 
#maximize     FALSE        FALSE        FALSE       
#yLimits      Numeric,2    Numeric,2    Numeric,2   
#times        List,3       List,3       List,3      

