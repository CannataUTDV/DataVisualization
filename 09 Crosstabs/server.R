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
          dataset="cannata/diamonds", type="sql",
          query="select color, clarity, 
            sum(price) as sum_price, 
            sum(carat) as sum_carat, 
            sum(price) / sum(carat) as ratio,
            case
            when sum(price) / sum(carat) < ? then '03 Low'
            when sum(price) / sum(carat) < ? then '02 Medium'
            else '01 High'
            end AS kpi
            from diamond
            group by color, clarity
            order by clarity",
          queryParameters = list(KPI_Low_Max_value, KPI_Medium_Max_value)
        )
      }
    )
    #View(df1())
    plot <- ggplot(df1()) + 
      geom_text(aes(x=color, y=clarity, label=sum_price), size=6) +
      geom_tile(aes(x=color, y=clarity, fill=kpi), alpha=0.50)
    plot
  }) 

  observeEvent(input$clicks, {
    print(as.numeric(input$clicks))
  })
})
