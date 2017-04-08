# server.R
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(data.world)
require(readr)

online = F

shinyServer(function(input, output) { 

  observeEvent(input$click1, {
    output$distPlot1 <- renderPlot({
      
      KPI_Low = input$KPI1     
      KPI_Medium = input$KPI2
      
      if(online) {
        #print("Getting from data.world")
        df1 <- query(
            data.world(propsfile = "www/.data.world"),
            dataset="cannata/superstoreorders", type="sql",
            query="select Category, State, 
            sum(Profit) as sum_profit, 
            sum(Sales) as sum_sales, 
            sum(Profit) / sum(Sales) as ratio,
            
            case
            when sum(Profit) / sum(Sales) < ? then '03 Low'
            when sum(Profit) / sum(Sales) < ? then '02 Medium'
            else '01 High'
            end AS kpi
            
            from SuperStoreOrders
            where Country_Region = 'United States of America' and
            Category in ('Chairs  and  Chairmats', 'Office Machines', 'Tables', 'Telephones and Communication')
            group by Category, State
            order by Category, State",
            queryParameters = list(KPI_Low, KPI_Medium)
          )
      }
      else {
        #print("Getting from csv")
        file_path = "www/SuperStoreOrders.csv"
        df <- readr::read_csv(file_path)
        df1 = df %>% 
          dplyr::filter(Country_Region == 'United States of America', Category %in% c('Chairs  and  Chairmats', 'Office Machines', 'Tables', 'Telephones and Communication')) %>%
          dplyr::group_by(Category, State) %>% 
          dplyr::summarize(sum_profit = sum(Profit), sum_sales = sum(Sales), ratio = sum(Profit) / sum(Sales), kpi = if_else(ratio <= KPI_Low, '03 Low', if_else(ratio <= KPI_Medium, '02 Medium', '01 High')))
      }
      View(df1)
      plot <- ggplot(df1) + 
        theme(axis.text.x=element_text(angle=90, size=16, vjust=0.5)) + 
        theme(axis.text.y=element_text(size=16, hjust=0.5)) +
        geom_text(aes(x=Category, y=State, label=sum_sales), size=6) +
        geom_tile(aes(x=Category, y=State, fill=kpi), alpha=0.50)
      plot
      })
  })
})
