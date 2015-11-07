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
   colnames(results) <- myNames; 
  # get the results
  results
 
#               boot632   LGOCV     LOOCV     cv        repeatedcv boot     
# TrainRMSE     0.619778  0.6275048 0.6309407 0.6192086 0.6192086  0.66943  
# TrainRsquared 0.4009745 0.3554037 0.3429081 0.3831812 0.3831812  0.3140373
# method        "knn"     "knn"     "knn"     "knn"     "knn"      "knn"    

#---------------------------------------------------------------------------

# All cross-validation methods applied using sapply (matrix result)
# regression example using knn (very fast); "none" is not allowed for lapply

  require(caret); data(BloodBrain); 
  cvMethods <- c("boot632","LGOCV","LOOCV","cv","repeatedcv", "boot" );
  all <- sapply(cvMethods ,function(x) {set.seed(123); print(x); tc <- trainControl(method=(x))
                    fit1 <- train(bbbDescr, logBBB, trControl=tc, method="knn") }); all 
  all[4, ]
  
#                boot632      LGOCV        LOOCV        cv           repeatedcv   boot        
# method       "knn"        "knn"        "knn"        "knn"        "knn"        "knn"       
# modelInfo    List,13      List,13      List,13      List,13      List,13      List,13     
# modelType    "Regression" "Regression" "Regression" "Regression" "Regression" "Regression"
# results      List,7       List,5       List,3       List,5       List,5       List,5      
# pred         NULL         NULL         List,4       NULL         NULL         NULL        
# bestTune     List,1       List,1       List,1       List,1       List,1       List,1      
# call         Expression   Expression   Expression   Expression   Expression   Expression  
# dots         List,0       List,0       List,0       List,0       List,0       List,0      
# metric       "RMSE"       "RMSE"       "RMSE"       "RMSE"       "RMSE"       "RMSE"      
# control      List,26      List,26      List,26      List,26      List,26      List,26     
# finalModel   List,7       List,7       List,7       List,7       List,7       List,7      
# preProcess   NULL         NULL         NULL         NULL         NULL         NULL        
# trainingData List,135     List,135     List,135     List,135     List,135     List,135    
# resample     List,3       List,3       NULL         List,3       List,3       List,3      
# resampledCM  NULL         NULL         NULL         NULL         NULL         NULL        
# perfNames    Character,2  Character,2  Character,2  Character,2  Character,2  Character,2 
# maximize     FALSE        FALSE        FALSE        FALSE        FALSE        FALSE       
# yLimits      Numeric,2    Numeric,2    Numeric,2    Numeric,2    Numeric,2    Numeric,2   
# times        List,3       List,3       List,3       List,3       List,3       List,3    

  
  ### END
