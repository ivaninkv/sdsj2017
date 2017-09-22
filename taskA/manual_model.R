rm(list = ls())
gc()

library(dstools)
library(tidyverse)
library(Matrix)
library(mlr)

train.data <- readr::read_rds('data/train.rds')
test.data <- readr::read_rds('data/test.rds')
sample.submsission <- readr::read_csv('data/sample_submission_a.csv')
train.data$target <- paste0('p', train.data$target)

X <- train.data %>% 
  select(-question_id, -paragraph, -question)
y <- train.data$target
X_pred <- test.data %>% 
  select(-question_id, -paragraph, -question)
X$paragraph_id <- as.factor(X$paragraph_id)
X_pred$paragraph_id <- as.factor(X_pred$paragraph_id)
X <- as.data.frame(model.matrix(~. - 1, X))
X$target <- as.factor(X$target)
X_pred <- as.data.frame(model.matrix(~. - 1, X_pred))

head(listLearners()[c('class', 'package')])

task <- makeClassifTask(data = X, target = 'target')
lrn <- makeLearner('classif.h2o.deeplearning', predict.type = 'prob')
model <- train(lrn, task)
readr::write_rds(model, 'model.h2o')
res <- predict(model, newdata = X_pred)
sample.submsission$prediction <- res[1]
readr::write_csv(sample.submsission, 'data/h2o.csv')








