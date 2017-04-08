# server.R
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(data.world)

shinyServer(function(input, output) {
  output$distPlot1 <- renderPlot({
    
    KPI_Low_Max_value = input$KPI1     
    KPI_Medium_Max_value = input$KPI2
    
    df1 <- eventReactive(input$clicks1, { 
      query(
        data.world(propsfile = "www/.data.world"),
        dataset="cannata/superstoreorders", type="sql",
        query="select Category, State, Sales,
        (sum(Profit) / sum(Sales)) * 100 as KPIProfitRatio
        from SuperStoreOrders
        where Country_Region = 'United States of America'
        group by Category, State, Sales
        order by State"
        #queryParameters = list(KPI_Low_Max_value, KPI_Medium_Max_value)
      )
    }
      )
    View(df1())
    plot <- ggplot(df1()) + 
      geom_text(aes(x=Category, y=State, label=Sales), size=6) #+
    #geom_tile(aes(x=Category, y=State, fill=KPIProfitRatio), alpha=0.25)
    plot
    }) 
  
  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
  })
