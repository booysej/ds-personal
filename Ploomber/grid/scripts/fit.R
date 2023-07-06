# Load required libraries
library(readr)
library(caret)
library(randomForest)
library(adabag)

# %% tags=["parameters"]
upstream <- list('features')
product <- NULL
model_type <- 'random-forest'
n_estimators <- NULL
criterion <- NULL
learning_rate <- NULL

# %%
df <- read_csv(paste0(upstream['features']))
X <- df[, !names(df) %in% 'target']
y <- df$target

# Add target back to the dataset for adabag's boosting function
df$target <- y

# %%
set.seed(42)
trainIndex <- createDataPartition(y, p = .67, list = FALSE, times = 1)
train_set <- df[trainIndex, ]
test_set <- df[-trainIndex, ]

# %%
if (model_type == 'random-forest') {
    model <- randomForest(target ~ ., data = train_set,
                        ntree = n_estimators)
} else if (model_type == 'ada-boost') {
    model <- boosting(target ~ ., data = train_set,
                    boos = TRUE, mfinal = n_estimators)
} else {
    stop(paste0("Unsupported model type: ", model_type))
}

# %%
y_pred <- predict(model, newdata = test_set)

# %%
print(confusionMatrix(data = as.factor(y_pred$class), reference = as.factor(test_set$target)))

# %%
save(model, file = paste0(product['model'], ".rda"))
