require("jsonlite")
require("RCurl")

# Change the USER and PASS below to be your credentials. Get your password from Edit profile -> Settings -> Advanced -> Copy API Token to clipboard. Also change cannata:test-emp-and-dept to yourAccount:yourDataset.
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ",
'oraclerest.cs.utexas.edu:5000/rest/native/?query=
"
select color, clarity, sum_price, round(sum_carat) as sum_carat, kpi as ratio, 
  case
when kpi < 3 then \'03 Low\'
when kpi < 5 then \'02 Medium\'
else \'01 High\'
end kpi
from (select color, clarity, 
sum(price) as sum_price, sum(carat) as sum_carat, 
sum(price) / sum(carat) as kpi
from diamonds
group by color, clarity)
order by clarity
"
')), httpheader=c(DB='jdbc:data:world:sql:cannata:test-emp-and-dept', USER='cannata', PASS=redacted, MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', e='1+2', ee='print("emp")'), verbose = TRUE) ))
print(summary(df))
print(head(df))

'
"select * from "
(lambda x:eval(compile(x,\"error\",\"single\")))(e)
""
'

