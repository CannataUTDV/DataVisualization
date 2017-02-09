require("jsonlite")
require("RCurl")

# Change the USER and PASS below to be your credentials. Get your password from Edit profile -> Settings -> Advanced -> Copy API Token to clipboard. Also change cannata:test-emp-and-dept to yourAccount:yourDataset.
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ",'oraclerest.cs.utexas.edu:5000/rest/native/?query="select * from emp"')),httpheader=c(DB='jdbc:data:world:sql:cannata:test-emp-and-dept', USER='cannata', PASS=redacted, MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
print(summary(df))
print(head(df))

