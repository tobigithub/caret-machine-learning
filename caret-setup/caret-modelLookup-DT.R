# Get all caret models for regression and classification and output in web browser
# The package DT is required
# See: https://github.com/topepo/caret/blob/master/pkg/caret/R/modelLookup.R
#
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

require(caret)
# install.packages("DT")
require(DT)

# this caret function returns the models and their availability 
# to perform regression  and classification
modelLookup()
#----------------------------------------------
# modelLookup()
# 'data.frame': 372 obs. of  6 variables:
#  $ model    : chr  "ada" "ada" "ada" "AdaBag" ...
#  $ parameter: Factor w/ 144 levels "iter","maxdepth",..: 1 2 3 4 2 4 2 5 6 8 ...
#  $ label    : Factor w/ 155 levels "#Trees","Learning Rate",..: 1 3 2 1 3 1 3 4 5 6 ...
#  $ forReg   : logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
#  $ forClass : logi  TRUE TRUE TRUE TRUE TRUE TRUE ...
#  $ probModel: 
#---------------------------------------------- 

#length of models in function
MAX = dim(modelLookup())[1];
#perform model Lookup
caretModels <- modelLookup()
#coerce into dataframe for web output
caretModels <- as.data.frame(caretModels)
class(caretModels)

# call web output with correct column names
datatable(caretModels,  options = list(
 		columnDefs = list(list(className = 'dt-left', targets = c(0,1,2,3,4,5,6))),
 		pageLength = MAX,
   		order = list(list(0, 'asc'))),
 		colnames = c('Num','model',' parameter', 'label', 'forReg', 'forClass',' probModel'),
 	        caption = paste('Caret models for regression and classification',Sys.time()),
 	        class = 'cell-border stripe')  %>% 	       
 	            formatStyle(2,
 		    background = styleColorBar(1, 'steelblue'),
 		    backgroundSize = '100% 90%',
 		    backgroundRepeat = 'no-repeat',
 		    backgroundPosition = 'center'
 )
 
### END

# Output will be in sortable table web browser and file index.html
# The table can be easily copy/pasted or saved as csv or XLS

# Num	model	parameter	label	forReg	forClass	probModel
#1	ada	iter	#Trees	false	true	true
#2	ada	maxdepth	Max Tree Depth	false	true	true
#3	ada	nu	Learning Rate	false	true	true
