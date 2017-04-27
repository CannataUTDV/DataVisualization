require(readr)
require(lubridate)
require(dplyr)
require(data.world)

online0 = TRUE

if(online0) {
  globals = query(
    data.world(propsfile = "www/.data.world"),
    dataset="cannata/superstoreorders", type="sql",
    query="select Order_Date, Sales
    from SuperStoreOrders
    order by 1"
  ) 
} else {
  file_path = "www/SuperStoreOrders.csv"
  df <- readr::read_csv(file_path) 
  globals <- df %>% dplyr::select(Order_Date, Sales) %>% dplyr::distinct()
}
globals$Order_Date <- lubridate::year(globals$Order_Date)

