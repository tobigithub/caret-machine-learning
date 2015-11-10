# All working and fast caret regression models applied to data(concrete)
# The regression output from  fast (working) regression models is
# exported to a sortable table in a web browser using the DT library
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

require(caret); require(DT); require(AppliedPredictiveModeling);
data(concrete);
 
m <- c( "avNNet" , "bagEarth", "bagEarthGCV", 
"bayesglm", "bdk", "blackboost", "Boruta", "brnn", "BstLm" , 
"bstTree", "cforest", "ctree", "ctree2", "cubist" , 
"dnn", "earth", "elm", "enet", "enpls",  
"gamLoess",  "gaussprLinear", "gaussprPoly", "gaussprRadial", 
"gcvEarth","glm", "glmboost", "glmnet", "icr", "kernelpls", 
"kknn", "knn",  "krlsRadial", "lars" , "lasso", 
"leapBackward", "leapForward", "leapSeq", "lm", "M5", "M5Rules", 
"mlpWeightDecay", "neuralnet" , "partDSA", 
"pcaNNet", "pcr", "penalized", "pls", "plsRglm", "ppr", 
"qrf" , "ranger",  "rf" , "rbfDDA",
"ridge", "rknn", "rlm", "rpart", "rpart2", "rqlasso", 
"rqnc", "RRF", "RRFglobal",  "rvmPoly", "rvmRadial", 
"SBC", "simpls", "spls", "superpc" , 
"svmLinear", "svmLinear2", "svmPoly", "svmRadial", "svmRadialCost", 
"treebag", "widekernelpls", "xgbLinear", 
"xgbTree", "xyf")
 
 
# load all packages (does not really work due to other dependencies)
suppressPackageStartupMessages(ll <-lapply(m, require, character.only = TRUE))
  
# define x and y for regression
y <- concrete$CompressiveStrength; x <- concrete[, 1:8];

# register parallel front-end
library(doParallel); cl <- makeCluster(detectCores()/2); registerDoParallel(cl)

# use lapply/loop to run everything
t2 <- lapply(m,function(i) 
	{cat("----------------------------------------------------","\n");
	set.seed(123); cat(i," <- loaded\n");
	t2 <- train(y=y, x=x, (i), trControl = trainControl(method = "boot632"))
	}
)

	
r2 <- lapply(1:length(t2), function(i) 
		{cat(sprintf("%-20s",(m[i])));
		cat(round(t2[[i]]$results$Rsquared[which.min(t2[[i]]$results$RMSE)],4),"\t");
		cat(round(t2[[i]]$results$RMSE[which.min(t2[[i]]$results$RMSE)],4),"\t")
		cat(t2[[i]]$times$everything[3],"\n")
		}
)

# stop cluster and register sequntial front end
stopCluster(cl); registerDoSEQ();

# preallocate data types
i = 1; MAX = length(t2);
x1 <- character() # Name
x2 <- numeric()   # R2
x3 <- numeric()   # RMSE
x4 <- numeric()   # time [s]
x5 <- character() # long model name
 
# fill data and check indexes and NA
for (i in 1:length(t2)) {
    x1[i] <- t2[[i]]$method
    x2[i] <- as.numeric(t2[[i]]$results$Rsquared[which.min(t2[[i]]$results$RMSE)])
    x3[i] <- as.numeric(t2[[i]]$results$RMSE[which.min(t2[[i]]$results$RMSE)])
    x4[i] <- as.numeric(t2[[i]]$times$everything[3])
    x5[i] <- t2[[i]]$modelInfo$label
}
  
# coerce to data frame
df1 <- data.frame(x1,x2,x3,x4,x5, stringsAsFactors=FALSE)

# print all results to R-GUI
df1

# plot RMSE vs boosting iterations for xgbLinear and xgbTree
# next 2 lines this is static code, index extraction may fail
ggplot(t2[[76]])
ggplot(t2[[77]])

# call web output with correct column names
datatable(df1,  options = list(
		columnDefs = list(list(className = 'dt-left', targets = c(0,1,2,3,4,5))),
		pageLength = MAX,
  		order = list(list(2, 'desc'))),
		colnames = c('Num', 'Name', 'R^2', 'RMSE', 'time [s]', 'Model name'),
	        caption = paste('Regression results from caret models',Sys.time()),
	        class = 'cell-border stripe')  %>% 	       
	        formatRound('x2', 3) %>%  
	        formatRound('x3', 3) %>%
	        formatRound('x4', 3) %>%
		    formatStyle(2,
		    background = styleColorBar(x2, 'steelblue'),
		    backgroundSize = '100% 90%',
		    backgroundRepeat = 'no-repeat',
		    backgroundPosition = 'center'
)


### END
