# Tune "svmRadial" in caret with evolutional algorithm using DEoptim.
# Author: Rafael Ladeira  https://github.com/rladeira
# Source: https://github.com/topepo/caret/issues/321
# 
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

library(caret)
library(parallel)
library(doMC)

set.seed(17516)
training_data <- SLC14_1(500)
testing_data <- SLC14_1(10^5)

registerDoMC(cores = detectCores())

svm_fit <- function(x) {
  mod <- train(y ~ ., data = training_data,
               method = "svmRadial",
               preProc = c("center", "scale"),
               trControl = trainControl(method = "cv"),
               tuneGrid = data.frame(C = 2^x[1], sigma = exp(x[2])))
  getTrainPerf(mod)[, "TrainRMSE"]
}

library(DEoptim)
library(kernlab)

## converged after 31 iterations
svm_de_obj <-  DEoptim(fn = svm_fit,
                       ## test cost values between ~0 and 2^10,
                       ## test sigma values between exp(-5) and 1
                       lower = c(-5, -5), 
                       upper = c(10, 0),
                       control = DEoptim.control(reltol = 1e-3,
                                                 steptol = 10,
                                                 itermax = 100))


fitted_params <- svm_de_obj$optim$bestmem

svm_model <- train(y ~ ., data = training_data,
                   method = "svmRadial",
                   preProc = c("center", "scale"),
                   trControl = trainControl(method = "cv", number = 10),
                   tuneGrid = data.frame(C = 2^fitted_params[1], 
                                         sigma = exp(fitted_params[2])))

predictions <- predict(svm_model, testing_data)

cat("Train RMSE:", getTrainPerf(svm_model)[, "TrainRMSE"], "\n")
cat("Test RMSE:", RMSE(predictions, testing_data$y))

## Train RMSE: 5.733844 
## Test RMSE: 5.758587
