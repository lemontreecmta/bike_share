bike_share
==========

Kaggle's bike sharing problem

http://www.kaggle.com/c/bike-sharing-demand

For this regression problem, I use different techniques (SVM, decision tree, random forest) to build classifiers. The result can be calculated in RMSE or RMSLE indices. I use cross-validation to test classifier before submit it to Kaggle. A paper describing individual techniques and choice of parameters will be up soon.

Result: Random forest is the best classifier out of the three. The optimal parameters for random forest (from my test) is ntree (number of trees) = 100 and mtry (number of random features to choose from at the split of each node for a tree) = 8, I get the RMSLE result of appx 0.48, which gives me 350th rank-ish out of 1100 at this moment (Nov 1 2014).

Possible improvement: For random forest, the R package allows adjustment of different parameters (sampling with or without replacement, size of sample to draw, minimum and maximum sizes of terminal nodes, etc) which can potentially lead to better result, (though I suspect it will not be a significant improvement). Other technique of tree ensembles may also yield better result with good choice of number of trees, weights and other important parameters. 


