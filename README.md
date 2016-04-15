bike_share
==========
###Kaggle's bike sharing problem

http://www.kaggle.com/c/bike-sharing-demand

###R packages

e1071, rpart, randomForest, Metrics and lubridate

###Installation

Download the data and load it into R in two objects: train and test. Then load file bike_share.r. The result will be written to a new file ("result.csv") in the current directory in submission format.

###Method

For this regression problem, I use SVM, decision tree, random forest to train classifiers. Then I use cross-validation to test classifier before submit it to Kaggle. The result is calculated in RMSLE indices. 

###Results and possible improvements

Result: Random forest is the best technique due to performance in RMSLE indices. The optimal parameters for random forest (from my test) is ntree (number of trees) = 100 and mtry (number of random features to choose from at the split of each node for a tree) = 8, I get the RMSLE result of appx 0.48, which gives me 350th rank-ish out of 1100 at this moment.




