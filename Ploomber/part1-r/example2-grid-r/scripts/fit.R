# Load required libraries
library(readr)
library(caret)
library(randomForest)

# %% tags=["parameters"]
upstream <- list('features')
product <- NULL
model_type <- 'random-forest'
n_estimators <- NULL
criterion <- NULL

# %%
df <- read_csv(paste0(upstream['features']))
colnames(df) <- c("petral_area", "petal_length", "petal_width", "sepal_area", "sepal_length", "sepal_width", "target")
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
}  else {
    stop(paste0("Unsupported model type: ", model_type))
}

# %%
y_pred <- predict(model, newdata = test_set)

# %%
test_set$y_pred <- round(y_pred)
print(mean(abs(test_set$target - test_set$y_pred)))

# %%
save(model, file = paste0(product['model']))
