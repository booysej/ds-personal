# + tags=["parameters"]
upstream = list('raw')
product = NULL
# -

df = read.csv(upstream$raw$data)

# clean the outlier from the sepal_length column where 
# the values are bigger than 2 times the standard deviations from the mean
the_sd = sd(df$sepal_length)
the_mean = mean(df$sepal_length)
df = df[df$sepal_length < the_mean + 1.5 * the_sd, ]
df

write.csv(df, product$data)