# Installation of caret package with commonly used 340 dependencies
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# installs most of the 340 caret dependencies + seven commonly used but not all of them
mostCommon <- c("caret", "ggplot2", "data.table", "plyr", "knitr", "shiny", "xts", "lattice")
install.packages(mostCommon, dependencies = c("Imports", "Depends", "Suggests"))          
require(caret); sessionInfo()

### END
