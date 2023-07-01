# + tags=["parameters"]
upstream = list('W1.raw')
product = NULL
# -


df = read.csv(upstream$W1.raw$data)

write.csv(df, product$data)