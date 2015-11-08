# Regression analysis and visualization
# Plot observed vs predicted values for training and test set from  CART and PLS
# Source: http://www.inside-r.org/packages/cran/caret/docs/plotObsVsPred
# Author: Max Kuhn
#
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# load libraries and models
require(caret)
require(mlbench)
data(BostonHousing)

# perform CART (Classification And Regression Tree) analysis
set.seed(123)
rpartFit <- train(BostonHousing[1:100, -c(4, 14)], 
                  BostonHousing$medv[1:100], 
                  "rpart", tuneLength = 9)

# perform PLS (Partial Least Squares) analysis
set.seed(123)
plsFit <- train(BostonHousing[1:100, -c(4, 14)], 
                BostonHousing$medv[1:100], 
                "pls")

# extract optimal tuning values for further use
predVals <- extractPrediction(list(rpartFit, plsFit), 
                              testX = BostonHousing[101:200, -c(4, 14)], 
                              testY = BostonHousing$medv[101:200], 
                              unkX = BostonHousing[201:300, -c(4, 14)])

# plot CART and PLS observed vs predicted values for training and test set
plotObsVsPred(predVals)

### END
