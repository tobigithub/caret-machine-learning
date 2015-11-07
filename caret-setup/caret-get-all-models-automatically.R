# Get all caret models for regression and classification
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

# -----------------------------------------------------------
# get all caret models for regression

require(caret)
modNames <- unique(modelLookup()[modelLookup()$forReg,c(1)])
length(modNames); modNames;

# -----------------------------------------------------------
# get all caret models for classification

require(caret)
modNames <- unique(modelLookup()[modelLookup()$forClass,c(1)])
length(modNames); modNames;
