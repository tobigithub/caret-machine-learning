# Installation of caret package with allmost all required caret libraries 
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)
 
# installs most of the 340 caret dependencies + seven commonly used but not all of them
mostCommon <- c("caret", "AppliedPredictiveModeling", "ggplot2", "data.table", "plyr", "knitr", "shiny", "xts", "lattice")
install.packages(mostCommon, dependencies = c("Imports", "Depends", "Suggests"))          

# then load caret and check which additional libraries covering 200 models need to be installed
require(caret); sessionInfo();
caretLibs <- unique(unlist(lapply(getModelInfo(), function(x) x$library)))
install.packages(caretLibs, dependencies = c("Imports", "Depends", "Suggests")) 

### END

