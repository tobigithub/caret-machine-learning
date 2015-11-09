# View and load ML datasets for working with caret 
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# load the dataset
data(iris)
# get the dimension of the dataset
dim(iris)
## [1] 150   5
# get the class name (here data frame)  to choose correct operators
class(iris)
## [1] "data.frame"

# invoke simple data viewer
View(iris)
# invoke the useless editor
edit(iris)
# get the data structure
str(iris)
> str(iris)
##'data.frame':   150 obs. of  5 variables:
## $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
## $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
## $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
## $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
## $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 

