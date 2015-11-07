# http://groupware.les.inf.puc-rio.br/har

library(caret)
require(ggplot2)
require(randomForest)

library(doSNOW)
library(parallel)

training_URL<-"http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test_URL<-"http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
training<-read.csv(training_URL,na.strings=c("NA",""))
test<-read.csv(test_URL,na.strings=c("NA",""))

training<-training[,7:160]
test<-test[,7:160]

mostly_data<-apply(!is.na(training),2,sum)>19621
training<-training[,mostly_data]
test<-test[,mostly_data]
dim(training)


#plot feature wise
#https://rpubs.com/davizuku/practical_ml
selCols <- grep("^accel_", names(training));
featurePlot(x = training[,selCols],
            y = training$classe,
            plot = "boxplot");

selCols <- grep("^magnet_", names(training));
featurePlot(x = training[,selCols],
            y = training$classe,
            plot = "boxplot");

selCols <- grep("^gyros_", names(training));
featurePlot(x = training[,selCols],
            y = training$classe,
            plot = "boxplot");


#plot training data
featurePlot(x=training[,c(1:12)], y=training$classe, plot = 'box')

InTrain<-createDataPartition(y=training$classe,p=0.3,list=FALSE)
training1<-training[InTrain,]

# detect true cores requires parallel()
nCores <- detectCores(logical = FALSE)
# detect threads
nThreads <- detectCores(logical = TRUE)

cl <- makeCluster(nThreads, type="SOCK")
registerDoSNOW(cl); cl;
getDoParWorkers()
getDoParName()

#------------------------------------------------------------
#  rf usually works
ptm <- proc.time()
rf_model<-train(classe~.,data=training1,method="rf")
            # method="repeatedcv", number=10, repeats=3 ## repeated k-fold Cross Validation
            # method="cv",number=5 ## k-fold Cross Validation
                # method="LOOCV" ## Leave One Out Cross Validation
                # method="boot", number=100 ## Bootstrap
                # method = "boot632" ## The .632+ Bootstrap 
                # trControl=trainControl(method="boot632"),
                # prox=TRUE,allowParallel=TRUE)
proc.time() - ptm

#------------------------------------------------------------
# knn
ptm <- proc.time()
model1<-train(classe~.,data=training1,method="knn")
proc.time() - ptm

#------------------------------------------------------------
# "repeatedcv" ##  repeated k-fold Cross Validation
ptm <- proc.time()
model2<-train(classe~.,data=training1,method="knn",
          trControl=trainControl(method="repeatedcv", number=3, repeats=3)) ## repeated k-fold Cross Validation
 proc.time() - ptm
#------------------------------------------------------------
#  "cv"  ##  k-fold Cross Validation
ptm <- proc.time()
model3<-train(classe~.,data=training1,method="knn",
          trControl=trainControl(method="cv",number=3))  ## k-fold Cross Validation
proc.time() - ptm
#------------------------------------------------------------
# "LOOCV" ## Leave One Out Cross Validation
ptm <- proc.time()
model4<-train(classe~.,data=training1,method="knn",
                  trControl=trainControl(method="LOOCV", repeats=1))  ## Leave One Out Cross Validation
proc.time() - ptm
#------------------------------------------------------------
#  "boot" ## Bootstrap
ptm <- proc.time()
model5<-train(classe~.,data=training1,method="knn",
                  trControl=trainControl(method="boot", number=10)) ## Bootstrap
proc.time() - ptm
#------------------------------------------------------------
#  "boot632" ## The .632+ Bootstrap 
ptm <- proc.time()
model6<-train(classe~.,data=training1,method="knn",
                 trControl=trainControl(method="boot632"))  ## The .632+ Bootstrap 
proc.time() - ptm
#------------------------------------------------------------
## Times for splits and trains
##                 user  system elapsed 
## rf............ 17.78    0.74  126.16
## knn...........  0.87    0.80   19.76
## knn-repeatedcv  0.75    0.56    3.12 
## knn-cv........  0.69    0.45    1.81
## knn-LOOCV..... 77.60   34.54  120.77
## knn-boot......  0.69    0.67    6.35
## knn-boot632     0.99    0.80   23.12
#------------------------------------------------------------
rf_model
model1
model2
model3
model4
model5
model6
#------------------------------------------------------------

print(rf_model)
print(rf_model$finalModel)
plot(rf_model$finalModel)
rf_model$results

#  number of variables per level (mtry)
confusionMatrix(rf_model)
plot(rf_model)

#QPLOT
qplot(roll_belt, magnet_dumbbell_y, colour=classe, data=training)  

rf_test <- predict(rf_model,test)
rf_test
# Correct solution
#B A B A A E D B A A B C B A E E A B B B

stopCluster(cl)

#--- register foreach for sequential mode
registerDoSEQ()

### END
