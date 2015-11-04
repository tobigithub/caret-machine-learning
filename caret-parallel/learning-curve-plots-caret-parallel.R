# Learning curve plots for R caret classifications and regressions in parallel 
# (ROC vs training size, RMSE vs training  size)
# Source: Max Kuhn (topepo); https://github.com/topepo/caret/issues/278
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

#----------------------------------------------------------------------
# Library parallel() is a native R library, no CRAN required
library(parallel)
nCores <- detectCores(logical = FALSE)
nThreads <- detectCores(logical = TRUE)
cat("CPU with",nCores,"cores and",nThreads,"threads detected.\n")

# load the doParallel/doSNOW library for caret cluster use
library(doParallel)
cl <- makeCluster(nThreads)
registerDoParallel(cl)

#----------------------------------------------------------------------
##   function: learning_curve_dat plots training-size vs RMSE or ROC
##        dat: entire data set used for modling
##          y: character stirng for the outcome column name
## proportion: proportion of data used to train the model
##  test_prop: proportion of data used initially set aside for testing
##    verbose: write out a log of training milestones
##        ...: arguments to pass to `train`
#----------------------------------------------------------------------
learning_curve_dat <- function(dat, 
                              outcome = colnames(dat)[1],
                              proportion = (1:10)/10, test_prop = 0, 
                              verbose = TRUE, ...) {

  proportion <- sort(unique(proportion))
  n_size <- length(proportion)

  if(test_prop > 0) {
    for_model <- createDataPartition(dat[, outcome], p = 1 - test_prop, list = FALSE)
  } else for_model <- 1:nrow(dat)

  n <- length(for_model)

  resampled <- vector(mode = "list", length = n_size)
  tested <- if(test_prop > 0) resampled else NULL
  apparent <- resampled
  for(i in seq(along = proportion)) {
    if(verbose) cat("Training for ", round(proportion[i]*100, 1), 
                    "% (n = ", floor(n*proportion[i]), ")\n", sep = "")
    in_mod <- if(proportion[i] < 1) sample(for_model, size = floor(n*proportion[i])) else for_model
    mod <- train(x = dat[in_mod, colnames(dat) != outcome, drop = FALSE],
                 y = dat[in_mod, outcome],
                 ...)
    if(i == 1) perf_names <- mod$perfNames
    resampled[[i]] <- merge(mod$resample, mod$bestTune)
    resampled[[i]]$Training_Size <- length(in_mod)

    if(test_prop > 0) {
      if(!mod$control$classProbs) {
        test_preds <- extractPrediction(list(model = mod), 
                                        testX = dat[-for_model, colnames(dat) != outcome, drop = FALSE],
                                        testY = dat[-for_model, outcome])
      } else {
        test_preds <- extractProb(list(model = mod), 
                                  testX = dat[-for_model, colnames(dat) != outcome, drop = FALSE],
                                  testY = dat[-for_model, outcome])
      }
      test_perf <- mod$control$summaryFunction(test_preds, lev = mod$finalModel$obsLevels)
      test_perf <- as.data.frame(t(test_perf))
      test_perf$Training_Size <- length(in_mod)
      tested[[i]] <- test_perf
      try(rm(test_preds, test_perf), silent = TRUE)
    }

    if(!mod$control$classProbs) {
      app_preds <- extractPrediction(list(model = mod), 
                                     testX = dat[in_mod, colnames(dat) != outcome, drop = FALSE],
                                     testY = dat[in_mod, outcome])
    } else {
      app_preds <- extractProb(list(model = mod), 
                               testX = dat[in_mod, colnames(dat) != outcome, drop = FALSE],
                               testY = dat[in_mod, outcome])
    }
    app_perf <- mod$control$summaryFunction(app_preds, lev = mod$finalModel$obsLevels)
    app_perf <- as.data.frame(t(app_perf))
    app_perf$Training_Size <- length(in_mod)    
    apparent[[i]] <- app_perf

    try(rm(mod, in_mod, app_preds, app_perf), silent = TRUE)
  }

  resampled <- do.call("rbind", resampled)
  resampled <- resampled[, c(perf_names, "Training_Size")]
  resampled$Data <- "Resampling"
  apparent <- do.call("rbind", apparent)
  apparent <- apparent[, c(perf_names, "Training_Size")]
  apparent$Data <- "Training"
  out <- rbind(resampled, apparent)
  if(test_prop > 0) {
    tested <- do.call("rbind", tested)
    tested <- tested[, c(perf_names, "Training_Size")]
    tested$Data <- "Testing"
    out <- rbind(out, tested)
  }
  out
}

#----------------------------------------------------------------------
# multiplot for plotting multiple ggplots
# Example: multiplot(p1,p2,p3,p4,p5,p6,cols=3)
# Source: http://www.peterhaschke.com/r/2013/04/24/MultiPlot.html
#----------------------------------------------------------------------

multiplot <- function(..., plotlist = NULL, file, cols = 1, layout = NULL) {
  require(grid)

  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  if (is.null(layout)) {
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

  if (numPlots == 1) {
    print(plots[[1]])

  } else {
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    for (i in 1:numPlots) {
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


#----------------------------------------------------------------------
## Classification example
#----------------------------------------------------------------------
library(caret)
library(xgboost)

# set plot to 2x3
par(mfrow=c(2,3)) 

set.seed(1412)
class_dat <- twoClassSim(2000)

set.seed(29510)
lda_data <- learning_curve_dat(dat = class_dat, outcome = "Class",
                              test_prop = 1/4, 
                              ## `train` arguments
                              method = "lda", 
                              metric = "ROC",
                              trControl = trainControl(classProbs = TRUE, 
                               			       method = "boot632",
                                                       summaryFunction = twoClassSummary))

p1 <- ggplot(lda_data, aes(x = Training_Size, y = ROC, color = Data)) + 
  geom_smooth(method = loess, span = .8) + 
  ggtitle("LDA classification with boot632 CV") +
  theme_bw()
p1
#----------------------------------------------------------------------
set.seed(29510)
rf_data <- learning_curve_dat(dat = class_dat, outcome = "Class",
                             test_prop = 1/4, 
                             ## `train` arguments
                             method = "rf", 
                             metric = "ROC",
                             tuneLength = 4,
                             trControl = trainControl(classProbs = TRUE, 
                                                      method = "boot632",
                                                      summaryFunction = twoClassSummary))

p2 <- ggplot(rf_data, aes(x = Training_Size, y = ROC, color = Data)) + 
  geom_smooth(method = loess, span = .8) + 
  ggtitle("rf classification with boot632 CV") +
  theme_bw()
p2
#----------------------------------------------------------------------
set.seed(29510)
rf_data <- learning_curve_dat(dat = class_dat, outcome = "Class",
                             test_prop = 1/4, 
                             ## `train` arguments
                             method = "parRF", 
                             metric = "ROC",
                             tuneLength = 4,
                             trControl = trainControl(classProbs = TRUE, 
                                                      method = "boot632",
                                                      summaryFunction = twoClassSummary))

p3 <- ggplot(rf_data, aes(x = Training_Size, y = ROC, color = Data)) + 
  geom_smooth(method = loess, span = .8) + 
  ggtitle("parRF classification with boot632 CV") +
  theme_bw()
p3
#----------------------------------------------------------------------
## Regression example
#----------------------------------------------------------------------

set.seed(19135)
reg_dat <- SLC14_1(2000)

set.seed(31535)
bag_data <- learning_curve_dat(dat = reg_dat, outcome = "y",
                              test_prop = 1/4, 
                              ## `train` arguments
                              method = "treebag", 
                              trControl = trainControl(method = "boot632"),
                              ## `bagging` arguments
                              nbagg = 100)

p4 <- ggplot(bag_data, aes(x = Training_Size, y = RMSE, color = Data)) + 
  geom_smooth(method = loess, span = .8) + 
  ggtitle("treebag regression with boot632 CV") +
  theme_bw()
p4


#----------------------------------------------------------------------
set.seed(31535)
svm_data <- learning_curve_dat(dat = reg_dat, outcome = "y",
                              test_prop = 0, 
                              ## `train` arguments
                              method = "svmRadial", 
                              preProc = c("center", "scale"),
                              tuneGrid = data.frame(sigma =  0.03, C = 2^10),
                              trControl = trainControl(method = "boot632"))

p5 <- ggplot(svm_data, aes(x = Training_Size, y = RMSE, color = Data)) + 
  geom_smooth(method = loess, span = .8) + 
  ggtitle("svmRadial regression with boot632 CV") +
  theme_bw()
p5

#----------------------------------------------------------------------
set.seed(31535)
svm_no_test <- learning_curve_dat(dat = reg_dat, outcome = "y",
                                 test_prop = 1/4, 
                                 ## `train` arguments
                                 method = "svmRadial", 
                                 preProc = c("center", "scale"),
                                 tuneGrid = data.frame(sigma =  0.03, C = 2^10),
                                 trControl = trainControl(method = "boot632"))

p6 <- ggplot(svm_no_test, aes(x = Training_Size, y = RMSE, color = Data)) + 
  geom_smooth(method = loess, span = .8) + 
  ggtitle("svmRadial regression with boot632 CV") +
  theme_bw()
p6

 
multiplot(p1,p2,p3,p4,p5,p6,cols=3)
  
stopCluster(cl)
registerDoSEQ()
### END
