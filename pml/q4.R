q1 <- function() {
  library(ElemStatLearn)
  data(vowel.train)
  data(vowel.test)
  set.seed(33833)
  vtr <- vowel.train
  vtr$y <- as.factor(vtr$y)
  vte <- vowel.test
  vte$y <- as.factor(vte$y)
  mod1 <- train(y ~.,method="gbm",data=vtr)
  mod2 <- train(y ~.,method="rf", data=vtr)
  
  pred1 <- predict(mod1,vte); pred2 <- predict(mod2,vte)
  predDF <- data.frame(pred1,pred2,y=vte$y)
  combModFit <- train(y ~.,method="gam",data=predDF)
}
q2 <- function() {
  library(caret)
  library(gbm)
  set.seed(3433)
  library(AppliedPredictiveModeling)
  data(AlzheimerDisease)
  adData = data.frame(diagnosis,predictors)
  inTrain = createDataPartition(adData$diagnosis, p = 3/4)[[1]]
  training = adData[ inTrain,]
  testing = adData[-inTrain,]
  
  #rf, gbm, lda
  
  mod_rf <- train(diagnosis ~.,method="rf", data=training)
  mod_gbm <- train(diagnosis ~.,method="gbm",data=training)
  mod_lda <- train(diagnosis ~.,method="lda",data=training)
  
  pred_rf <- predict(mod_rf, testing, method='raw')
  pred_gbm <- predict(mod_gbm, testing, method='raw')
  pred_lda <- predict(mod_lda, testing, method='raw')
  predDF <- data.frame(pred_gbm,pred_lda,pred_rf,diagnosis=testing$diagnosis)
}

q3 <- function() {
  set.seed(3523)
  library(AppliedPredictiveModeling)
  data(concrete)
  inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
  training <<- concrete[ inTrain,]
  testing <<- concrete[-inTrain,]
  set.seed(233)
  m <- train(CompressiveStrength ~ ., data=training, method="lasso")
  plot.enet(m$finalModel, xvar = "penalty", use.color = TRUE)
}

q4 <- function() {
  dat = read.csv("c:/scratch/gaData.csv")
  library(lubridate)
  training <<- dat[year(dat$date) < 2012,]
  testing <<- dat[(year(dat$date)) > 2011,]
  tstrain <<- ts(training$visitsTumblr)
  m <<- bats(tstrain)
  f <<- forecast(m,235)
  up95 <<- f$upper[,'95%']
  lo95 <<- f$lower[,'95%']
  table(testing$visitsTumblr >= lo95 & testing$visitsTumblr <= up95)
}

q5 <- function() {
  set.seed(3523)
  library(AppliedPredictiveModeling)
  data(concrete)
  inTrain = createDataPartition(concrete$CompressiveStrength, p = 3/4)[[1]]
  training <<- concrete[ inTrain,]
  testing <<- concrete[-inTrain,]
  set.seed(325)
  s <- svm(CompressiveStrength ~ ., data=training)
  p <- predict(s, testing)
  library(ModelMetrics)
  rmse(p, testing$CompressiveStrength)
}