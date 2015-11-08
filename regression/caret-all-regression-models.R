# Run all caret regression models in parallel and compare R^2 and RMSE
# Example data is the very small "cars" dataset. Replace with your own set.
# The regression output from 85 fast (working) regression models is
# exported to a sortable table in a web browser using the DT library
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# load caret and DT the cars data set
require(caret); require(DT);  data(cars);

# fill variable m with the working models  
m <- c("avNNet", "bagEarth", "bagEarthGCV", 
"bayesglm", "bdk", "blackboost", "Boruta", "brnn", "BstLm" , 
"bstTree", "cforest", "ctree", "ctree2", "cubist", "DENFIS", 
"dnn", "earth", "elm", "enet", "enpls", "evtree", 
"extraTrees",  "gamLoess",  "gaussprLinear", "gaussprPoly", "gaussprRadial", 
"gcvEarth","glm", "glmboost", "glmnet", "icr", "kernelpls", 
"kknn", "knn",  "krlsRadial", "lars" , "lasso", 
"leapBackward", "leapForward", "leapSeq", "lm", "M5", "M5Rules", 
"mlpWeightDecay", "neuralnet" , "partDSA", 
"pcaNNet", "pcr", "penalized", "pls", "plsRglm", "ppr", 
"qrf" , "ranger",  "rf", "rfRules", "rbfDDA",
"ridge", "rknn", "rknnBel", "rlm", "rpart", "rpart2", "rqlasso", 
"rqnc", "RRF", "RRFglobal",  "rvmPoly", "rvmRadial", 
"SBC", "simpls", "spls", "superpc" , 
"svmLinear", "svmLinear2", "svmPoly", "svmRadial", "svmRadialCost", 
"treebag", "widekernelpls", "WM", "xgbLinear", 
"xgbTree", "xyf")
 
 
# load all packages (does not really work due to other dependencies)
suppressPackageStartupMessages(ll <-lapply(m, require, character.only = TRUE))

# define x and y for regression
y <- mtcars$mpg; x <- mtcars[, -mtcars$mpg];

# load all libraries
library(doParallel); cl <- makeCluster(detectCores()); registerDoParallel(cl)

# use lapply/loop to run everything
t2 <- lapply(m,function(i) 
	{cat("----------------------------------------------------","\n");
	set.seed(123); cat(i," <- loaded\n");
	t2 <- train(y=y, x=x, (i), trControl = trainControl(method = "boot632"))
	}
)

# use lapply to print the results
r2 <- lapply(1:length(t2), function(i) 
		{cat(sprintf("%-20s",(m[i])));
		cat(round(t2[[i]]$results$Rsquared[which.min(t2[[i]]$results$RMSE)],4),"\t");
		cat(round(t2[[i]]$results$RMSE[which.min(t2[[i]]$results$RMSE)],4),"\t")
		cat(t2[[i]]$times$everything[3],"\n")
		}
)

# stop the parallel processing and register sequential front-end
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

# call web browser output with sortable column names
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

#-----------------------------------------------------------------------------
# Num	Name	R^2	RMSE	time[s]	Model name
# #1	avNNet		20.269	4.98	Model Averaged Neural Network
# 2	bagEarth	1	0	3.8	Bagged MARS
# 3	bagEarthGCV	1	0	2.22	Bagged MARS using gCV Pruning
# 4	bayesglm	1	0	1.11	Bayesian Generalized Linear Model
# 5	bdk	0.81	2.602	1.49	Self-Organizing Map
# 6	blackboost	0.878	2.37	3.9	Boosted Tree
# 7	Boruta	0.965	1.317	25.79	Random Forest with Additional Feature Selection
# 8	brnn	0.999	0.215	0.95	Bayesian Regularized Neural Networks
# 9	BstLm	0.826	2.661	2.89	Boosted Linear Model
# 10	bstTree	0.912	1.766	17.98	Boosted Tree
...
# 83	xgbTree	0.983	0.679	3.970	eXtreme Gradient Boosting
# 84	xyf	0.834	2.609	1.560	Self-Organizing Maps
#-----------------------------------------------------------------------------

### total time 385.14 [s] or 6.4 min with 4c/16t@4.2 GHz



