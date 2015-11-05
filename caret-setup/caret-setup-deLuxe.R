# Installation of caret package with allmost 400 required caret dependencies 
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# 1) load few caret packages from BioConductor, this will create most troubles
# this is a static solution (not good) check with below URL for more info
# https://github.com/topepo/caret/blob/master/release_process/update_pkgs.R
# Answer "n" when asked for updates 
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite(c("arm", "gpls", "logicFS", "vbmp"))
 
# 2) installs most of the 340 caret dependencies + seven commonly used but not all of them
# Make sure to allow firewall access for doMPI if needed
mostCommon <- c("caret", "AppliedPredictiveModeling", "ggplot2", "data.table", "plyr", "knitr", "shiny", "xts", "lattice")
install.packages(mostCommon, dependencies = c("Imports", "Depends", "Suggests"))          

# 3) then load caret and check which additional libraries covering 200 models need to be installed
# warnings will still exist; because caret loaded few dependencies they can not be updated
# during runtime, may create errors
require(caret); sessionInfo();
caretLibs <- unique(unlist(lapply(getModelInfo(), function(x) x$library)))
detach("package:caret", unload=TRUE)
install.packages(caretLibs, dependencies = c("Imports", "Depends", "Suggests")) 

# 4) load packages from R-Forge
install.packages(c("CHAID"), repos="http://R-Forge.R-project.org")
 
# 5) Restart R, clean-up mess, and say 'y' when asked
# All packages that are not in CRAN such as SDDA need to be installed by hand
source("http://bioconductor.org/biocLite.R")
biocLite()
biocLite(c("gpls", "logicFS", "rPython", "SDDA", "vbmp"))

# "Warning: cannot remove prior installation of package"
# in case of final installation issues, check packages plyr, MASS and ggplot2
# the library directories may have to be removed manually with Administrator access.
# get the library location with .libPaths()
# R has to be closed and restarted and the following two lines below have to be executed
# (additional issues may occour under WIN with doMPI and msmpi.dll)

## rP <- c("plyr","ggplot2","MASS")
## install.packages(rP, dependencies = c("Imports", "Depends", "Suggests")) 

### END

