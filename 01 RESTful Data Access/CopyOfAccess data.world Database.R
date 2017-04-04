
require(data.world)

conn <- data.world()

result <- query(conn, dataset="cannata/diamonds", type="sql",
                query="
                select color, clarity, 
                sum(price) as sum_price, 
                sum(carat) as sum_carat, 
                sum(price) / sum(carat) as ratio,
                case
                when sum(price) / sum(carat) < ? then '03 Low'
                when sum(price) / sum(carat) < ? then '02 Medium'
                else '01 High'
                end AS kpi
                from diamonds
                group by color, clarity
                order by clarity
                "
                ,queryParameters = list(3000, 5000)
)
View(result)

