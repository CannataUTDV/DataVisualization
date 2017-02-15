df <- read.csv("/Users/pcannata/Downloads/SuperStoreOrders.csv", stringsAsFactors = FALSE)
summary(df)
head(df)

p = dplyr::filter(df, Region == "International" | Region == "East") %>% ggplot(.) + geom_boxplot(aes(x=Category, y=Sales, colour=Region)) +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))
print(p)
