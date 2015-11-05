# Installation of caret package with allmost 400 required caret dependencies 
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)
 
# installs most of the 340 caret dependencies + seven commonly used but not all of them
mostCommon <- c("caret", "AppliedPredictiveModeling", "ggplot2", "data.table", "plyr", "knitr", "shiny", "xts", "lattice")
install.packages(mostCommon, dependencies = c("Imports", "Depends", "Suggests"))          

# then load caret and check which additional libraries covering 200 models need to be installed
# warnings will still exist
require(caret); sessionInfo();
caretLibs <- unique(unlist(lapply(getModelInfo(), function(x) x$library)))
install.packages(caretLibs, dependencies = c("Imports", "Depends", "Suggests")) 

# now load caret packages from BioConductor
# this is a static solution (not good) check with below URL for more info
# https://github.com/topepo/caret/blob/master/release_process/update_pkgs.R
source("https://bioconductor.org/biocLite.R")
biocLite()
biocLite(c("arm", "gpls", "logicFS", "vbmp"))

# "Warning: cannot remove prior installation of package"
# in case of final installation issues, check packages plyr, MASS and ggplot2
# the library directories may have to be removed manually with Administrator access.
# get the library location with .libPaths()
# R has to be closed and restarted and the following two lines below have to be executed
# (additional issues may occour under WIN with doMPI and msmpi.dll)

## rP <- c("plyr","ggplot2","MASS")
## install.packages(rP, dependencies = c("Imports", "Depends", "Suggests")) 

### END

