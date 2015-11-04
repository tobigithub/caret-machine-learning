# Run caret models "cubist" in parallel
# https://github.com/tobigithub/caret-machine-learning
# Tobias Kind (2015)

library(doParallel); cl <- makeCluster(16); registerDoParallel(cl) 
  require(caret); data(BloodBrain); 
  fit1 <- train(bbbDescr, logBBB, "cubist"); 
  fit1; fit1$times$everything
stopCluster(cl); registerDoSEQ();

# /user time/ is the actual caret training time
# /system time/ is operating system overhead
# /elapse time/ is total run-time 

# for parallel 2x total speed-up
# but parallel 45x training speed-up (!)
# parallel and caret overhead are 42 sec
# Hence oberhead for short methods is quite large
# Overhead for longer train methods will be small

# Cubist with one CPU [s]
# user  system elapsed 
# 91.20    0.04   91.27 

# Cubist with 16 CPUs [s]
# user  system elapsed 
# 2.00    0.03   44.68 
