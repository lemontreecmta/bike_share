##...read train and test from data downloaded from kaggle.com 
library(e1071) # import svm package
library(rpart) # import decision tree package
library(randomForest) #import random forest package

library(Metrics)
library(lubridate)
train$hour <-hour(train$datetime)
test$hour <- hour(test$datetime)
train$dow <- wday(train$datetime)
test$dow <- wday(test$datetime)

## support vector machine 

# train data, double check with cross validation 

#segment data in different part, train the first part to test on the second (adjust number for different segmentation)
train.a<-train[1:8000,]
train.b<-train[8001:10886,]
train.1a<-train[1:2000, ]
train.1b<-train[4887:10886,]
train.a<-rbind(train.1a, train.1b)
train.b<-train[1:2886, ]

svm.model<- svm(count ~ season + holiday + 
                  weather + dow+ hour + temp + atemp+humidity+
                  windspeed , data=train.1a,  
                cost = 0.03, gamma = 0.025)
prediction<-predict(svm.model, train.1b)
train.1b$predicted.count<-0
train.1b$predicted.count = prediction
# because regression model can output negative result, set all negative to 1
train.1b$predicted.count[train.b$predicted.count<0] = 1
rmse(train.1b$count, train.b$predicted.count)

# train model and output test data's prediction to submit to Kaggle

test.count<-0
svm.model<- svm(count ~ season + holiday + 
                  weather + dow+ hour + temp + atemp+humidity+
                  windspeed , data=train.1a,  
                cost = 0.03, gamma = 0.025)
prediction<-predict(svm.model, test)
test$count = prediction
submit <- data.frame(datetime = test$datetime, count = test$count)
write.csv(submit, file = "rpart.csv", row.names = FALSE)

## decision tree - one tree

#cross validation of training data

#segment data in different part, train the first part to test on the second
train.a<-train[1:8000,]
train.b<-train[8001:10886,]

train.1a<-train[1:2000, ]
train.1b<-train[4887:10886,]
train.a<-rbind(train.1a, train.1b)
train.b<-train[1:2886, ]

regression.tree<-rpart(count~ season + holiday +
                    weather + dow + hour + 
                    temp + atemp + humidity + 
                    windspeed, data=train.a, method = "anova")

prediction<-predict(regression.tree, train.b)
train.b$predicted.count<-0
train.b$predicted.count = prediction
rmsle(train.b$count, train.b$predicted.count)
rmse(train.b$count, train.b$predicted.count)

# train model and output test data's prediction to submit to Kaggle

test.count<-0
regression.tree<-rpart(count~ season + holiday +
                         weather + dow + hour + 
                         temp + atemp + humidity + 
                         windspeed, data=train, method = "anova")

prediction<-predict(regression.tree, test)
test$count = prediction
submit <- data.frame(datetime = test$datetime, count = test$count)
write.csv(submit, file = "rpart.csv", row.names = FALSE)

#result: 0.90242 

##random forest

#segment data in different part, train the first part to test on the second
train.a<-train[1:8000,]
train.b<-train[8001:10886,]

train.1a<-train[1:6000, ]
train.1b<-train[8887:10886,]
train.a<-cbind(train.1a, train.1b)
train.b<-train[8001:10886, ]

random.forest<-randomForest(count~ season + holiday +
                              weather + dow + hour + 
                              temp + atemp + humidity + 
                              windspeed, data=train.a, ntree = 100, mtry = 8, 
                            importance = TRUE)
train.b$p.count<-0
prediction<-predict(random.forest, train.b)
train.b$p.count<-prediction
rmsle(train.b$p.count, train.b$count)
rmse(train.b$p.count, train.b$count)  

# train model and output test data's prediction to submit to Kaggle

test$count<-0
random.forest<-randomForest(count~ season + holiday +
                              weather + dow + hour + 
                              temp + atemp + humidity + 
                              windspeed, data=train, ntree = 100, mtry = 8, importance = TRUE)
prediction<-predict(random.forest, test)
test$count<-prediction
submit <- data.frame(datetime = test$datetime, count = test$count)
write.csv(submit, file = "randomforest.csv", row.names = FALSE)

#result: 0.60277 (with mtry (random selected features) = p/3)
# 0.48810 (with mtry = 7)
# 0.48315 (with mtry = 8)
