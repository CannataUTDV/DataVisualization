# df <- read.csv("/Users/pcannata/Downloads/SuperStoreOrders.csv", stringsAsFactors = FALSE)

'
I loaded my REST server onto my Mac so I could run it exclusively during class.
To do this:
   Download my REST server and unzip it
   cd to the unzipped folder
   cd CarnotDist/CarnotRE
   ../dist/bin/jython -J-Xmx1g restful_start.py
   then use localhost:5011 below
'
   
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ",'localhost:5011/rest/native/?query="select * from SuperStoreOrders"')),httpheader=c(DB='jdbc:data:world:sql:cannata:superstoreorders', USER='cannata', PASS=redacted, MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
summary(df)
head(df)

p = dplyr::filter(df, Region == "International" | Region == "East") %>% ggplot(.) + geom_boxplot(aes(x=Category, y=Sales, colour=Region)) +
  theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))
print(p)
