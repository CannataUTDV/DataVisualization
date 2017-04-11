# server.R
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(data.world)
require(readr)
require(DT)

shinyServer(function(input, output) { 
  online1 = reactive({input$rb1})
  online2 = reactive({input$rb2})
  KPI_Low = reactive({input$KPI1})     
  KPI_Medium = reactive({input$KPI2})

# Begin Crosstab Tab ------------------------------------------------------------------
  df1 <- eventReactive(input$click1, {
      if(online1() == "SQL") {
        print("Getting from data.world")
        query(
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
            queryParameters = list(KPI_Low(), KPI_Medium())
          ) # %>% View()
      }
      else {
        print("Getting from csv")
        file_path = "www/SuperStoreOrders.csv"
        df <- readr::read_csv(file_path)
        df %>% 
          dplyr::filter(Country_Region == 'United States of America', Category %in% 
                          c('Chairs  and  Chairmats',
                            'Office Machines',
                            'Tables',
                            'Telephones and Communication')) %>%
          dplyr::group_by(Category, State) %>% 
          dplyr::summarize(sum_profit = sum(Profit), sum_sales = sum(Sales),
                           ratio = sum(Profit) / sum(Sales),
                           kpi = if_else(ratio <= KPI_Low(), '03 Low',
                           if_else(ratio <= KPI_Medium(), '02 Medium', '01 High'))) # %>% View()
      }
  })
  output$data1 <- renderDataTable({DT::datatable(df1(), rownames = FALSE,
                                extensions = list(Responsive = TRUE, FixedHeader = TRUE)
  )
  })
  output$plot1 <- renderPlot({ggplot(df1()) + 
    theme(axis.text.x=element_text(angle=90, size=16, vjust=0.5)) + 
    theme(axis.text.y=element_text(size=16, hjust=0.5)) +
    geom_text(aes(x=Category, y=State, label=sum_sales), size=6) +
    geom_tile(aes(x=Category, y=State, fill=kpi), alpha=0.50)
  })
# End Crosstab Tab ___________________________________________________________
# Begin Barchart Tab ------------------------------------------------------------------
  df2 <- eventReactive(input$click2, {
    if(online2() == "SQL") {
      print("Getting from data.world")
      tdf = query(
        data.world(propsfile = "www/.data.world"),
        dataset="cannata/superstoreorders", type="sql",
        query="select Category, Region, sum(Sales) sum_sales
                from SuperStoreOrders
                group by Category, Region"
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "www/SuperStoreOrders.csv"
      df <- readr::read_csv(file_path)
      tdf = df %>% 
        dplyr::group_by(Category, Region) %>% 
        dplyr::summarize(sum_sales = sum(Sales)) # %>% View()
    }
    # The following two lines mimic what can be done with Analytic SQL. Analytic SQL does not currently work in data.world.
    tdf2 = tdf %>% group_by(Category) %>% summarize(window_avg_sales = mean(sum_sales))
    dplyr::inner_join(tdf, tdf2, by = "Category")
    # Analytic SQL would look something like this:
      # select Category, Region, sum_sales, avg(sum_sales) 
      # OVER (PARTITION BY Category ) as window_avg_sales
      # from (select Category, Region, sum(Sales) sum_sales
      #       from SuperStoreOrders
      #      group by Category, Region)
  })
  output$data2 <- renderDataTable({DT::datatable(df2(), rownames = FALSE,
                        extensions = list(Responsive = TRUE, FixedHeader = TRUE)
  )
  })
  output$plot2 <- renderPlot({ggplot(df2(), aes(x=Region, y=sum_sales)) +
      scale_y_continuous(labels = scales::comma) + # no scientific notation
      theme(axis.text.x=element_text(angle=0, size=12, vjust=0.5)) + 
      theme(axis.text.y=element_text(size=12, hjust=0.5)) +
      geom_bar(stat = "identity") + 
      facet_wrap(~Category, ncol=1) + 
      coord_flip() + 
      # Add sum_sales, and (sum_sales - window_avg_sales) label.
      geom_text(mapping=aes(x=Region, y=sum_sales, label=round(sum_sales)),colour="black", hjust=-.5) +
      geom_text(mapping=aes(x=Region, y=sum_sales, label=round(sum_sales - window_avg_sales)),colour="blue", hjust=-2) +
      # Add reference line with a label.
      geom_hline(aes(yintercept = window_avg_sales), color="red") +
      geom_text(aes( -1, window_avg_sales, label = window_avg_sales, vjust = -.5, hjust = -.25), color="red")
  })
  # End Barchart Tab ___________________________________________________________
  
})
