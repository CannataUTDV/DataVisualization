# server.R
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(data.world)
require(readr)
require(DT)
require(leaflet)
require(plotly)
require(lubridate)

online0 = TRUE

# Server.R structure:
#   Queries that don’t need to be redone
#   shinyServer
#   widgets
#   tab specific queries and plotting

# The following query is for the select list in the Boxplots -> Simple Boxplot tab, and Barcharts -> Barchart with Table Calculation tab.
if(online0) {
  regions = query(
    data.world(propsfile = "www/.data.world"),
    dataset="cannata/superstoreorders", type="sql",
    query="select distinct Region as D, Region as R
    from SuperStoreOrders
    order by 1"
  ) # %>% View()
} else {
  print("Getting Regions from csv")
  file_path = "www/SuperStoreOrders.csv"
  df <- readr::read_csv(file_path) 
  tdf1 = df %>% dplyr::distinct(Region) %>% arrange(Region) %>% dplyr::rename(D = Region)
  tdf2 = df %>% dplyr::distinct(Region) %>% arrange(Region) %>% dplyr::rename(R = Region)
  regions = bind_cols(tdf1, tdf2)
}
region_list <- as.list(regions$D, regions$R)
region_list <- append(list("All" = "All"), region_list)
region_list5 <- region_list

# The following queries are for the Barcharts -> High Discount Orders tab data.
if(online0) {
# Step 1:
  highDiscounts <- query(
  data.world(propsfile = "www/.data.world"),
  dataset="cannata/superstoreorders", type="sql",
  query="
  SELECT distinct Order_Id, sum(Discount) as sumDiscount, sum(Sales) as
  sumSales
  FROM SuperStoreOrders
  where Region != 'International'
  group by Order_Id
  having sum(Discount) >= .3"
) # %>% View()
  # View(highDiscounts )

# Step 2
  highDiscountCustomers <- query(
    data.world(propsfile = "www/.data.world"),
    dataset="cannata/superstoreorders", type="sql",
    query="
    SELECT distinct Customer_Name, City, State, Order_Id
    FROM SuperStoreOrders
    where Order_Id in
    (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    order by Order_Id",
    queryParameters = highDiscounts$Order_Id
  ) # %>% View()
    # View(highDiscountCustomers)
    
# Step 3
    stateAbreviations <- query(
      data.world(propsfile = "www/.data.world"),
      dataset="cannata/superstoreorders", type="sql",
      query="SELECT distinct name as State, abbreviation as Abbreviation
      FROM markmarkoh.`us-state-table`.`state_table.csv/state_table`
      where name in
      (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      order by name",
      queryParameters = highDiscountCustomers$State
    ) # %>% View()
    # View(stateAbreviations )
    
# Step 4
    highDiscountCustomers2 <- left_join(highDiscountCustomers,
                                        stateAbreviations, by="State") # %>% View()
    # View(highDiscountCustomers2)
    
# Step 5
    longLat <- query(
      data.world(propsfile = "www/.data.world"),
      dataset="cannata/superstoreorders", type="sql",
      query="SELECT distinct NAME as City, STATE as Abbreviation,
      LATITUDE AS Latitude,
      LONGITUDE AS Longitude
      FROM bryon.`dhs-city-location-example`.`towns.csv/towns`
      where NAME in
      (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      order by NAME",
      queryParameters = highDiscountCustomers$City
    ) # %>% View()
    # View(longLat)
    
# Step 6
    highDiscountCustomers2LongLat <- 
      inner_join(highDiscountCustomers2, longLat, by = c("City", "Abbreviation")) 
    # View(highDiscountCustomers2LongLat)
    
# Step 7
    discounts <- 
      inner_join(highDiscountCustomers2LongLat, highDiscounts, by="Order_Id") # %>% View()
    # View(discounts)

  OLDdiscounts <- query(
    data.world(propsfile = "www/.data.world"),
    dataset="cannata/superstoreorders", type="sql",
    query="SELECT Customer_Name as CustomerName, s.City as City, states.abbreviation as State, 
    c.LATITUDE AS Latitude, 
    c.LONGITUDE AS Longitude, 
    Order_Id as OrderId, sum(Discount) as sumDiscount
    FROM SuperStoreOrders s join markmarkoh.`us-state-table`.`state_table.csv/state_table` states
    ON (s.State = states.name AND s.City = c.NAME) join
    bryon.`dhs-city-location-example`.`towns.csv/towns` c 
    ON (states.abbreviation = c.STATE)
    WHERE Region != 'International'
    group by Customer_Name, s.City, states.abbreviation, c.LATITUDE, c.LONGITUDE, Order_Id -- Note the absence of LATITUDE and LONGITUDE
    having sum(Discount) between .3 and .9"
  )  # %>% View()
} else {
  # Just faking one data point for now.
  Customer_Name = 'Wesley Tate'
  City = 'Chicago'
  State = 'Illinois'
  Order_Id = 48452
  Abbreviation = 'IL'
  Latitude =  41.85003
  Longitude = -87.65005
  sumDiscount = 0.34
  sumSales = 7124
  discounts <- data.frame(Customer_Name, City, State, Order_Id, Abbreviation, Latitude, Longitude, sumDiscount, sumSales)
}

# The following query is for the Barcharts -> High Sales Customers tab data.
if(online0) {
  # Step 1:
  highDiscounts <- query(
    data.world(propsfile = "www/.data.world"),
    dataset="cannata/superstoreorders", type="sql",
    query="
    SELECT distinct Order_Id, sum(Discount) as sumDiscount
    FROM SuperStoreOrders
    group by Order_Id
    having sum(Discount) >= .3"
  ) # %>% View()
  # View(highDiscounts)
  
  # Step 2
  sales <- query(
    data.world(propsfile = "www/.data.world"),
    dataset="cannata/superstoreorders", type="sql",
    query="
    select Customer_Id, sum(Profit) as sumProfit
    FROM SuperStoreOrders
    where Order_Id in 
      (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    group by Customer_Id",
    queryParameters = highDiscounts$Order_Id
    ) # %>% View()
  # View(sales)
} else {
  print("Getting discounts from csv")
  file_path = "www/SuperStoreOrders.csv"
  df <- readr::read_csv(file_path) 
  # Step 1
  highDiscounts <- df %>% dplyr::group_by(Order_Id) %>% dplyr::summarize(sumDiscount = sum(Discount)) %>% dplyr::filter(sumDiscount >= .3)
  # View(highDiscounts)
  # Step 2
  sales <- df %>% dplyr::filter(Order_Id %in% highDiscounts$Order_Id) %>% dplyr::select(Customer_Name, Customer_Id, City, State, Order_Id, Profit) %>% dplyr::group_by(Customer_Name, Customer_Id, City, State, Order_Id) %>% dplyr::summarise(sumProfit = sum(Profit))
  # View(sales)
}

############################### Start shinyServer Function ####################

shinyServer(function(input, output) {   
  # These widgets are for the Box Plots tab.
  online5 = reactive({input$rb5})
  output$boxplotRegions <- renderUI({selectInput("selectedBoxplotRegions", "Choose Regions:",
                                                 region_list5, multiple = TRUE, selected='All') })
  
  # These widgets are for the Histogram tab.
  online4 = reactive({input$rb4})
  
  # These widgets are for the Scatter Plots tab.
  online3 = reactive({input$rb3})
  
  # These widgets are for the Crosstabs tab.
  online1 = reactive({input$rb1})
  KPI_Low = reactive({input$KPI1})     
  KPI_Medium = reactive({input$KPI2})
  
  # These widgets are for the Barcharts tab.
  online2 = reactive({input$rb2})
  output$regions2 <- renderUI({selectInput("selectedRegions", "Choose Regions:", region_list, multiple = TRUE, selected='All') })
  
  # Begin Box Plot Tab ------------------------------------------------------------------
  dfbp1 <- eventReactive(input$click5, {
    if(input$selectedBoxplotRegions == 'All') region_list5 <- input$selectedBoxplotRegions
    else region_list5 <- append(list("Skip" = "Skip"), input$selectedBoxplotRegions)
    if(online5() == "SQL") {
      print("Getting from data.world")
      df <- query(
        data.world(propsfile = "www/.data.world"),
        dataset="cannata/superstoreorders", type="sql",
        query="select Category, Sales, Region, Order_Date
        from SuperStoreOrders
        where (? = 'All' or Region in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?))",
        queryParameters = region_list5 ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "www/SuperStoreOrders.csv"
      df <- readr::read_csv(file_path)
      df %>% dplyr::select(Category, Sales, Region, Order_Date) %>% dplyr::filter(Region %in% input$selectedBoxplotRegions | input$selectedBoxplotRegions == "All") # %>% View()
    }
    })
  
  output$boxplotData1 <- renderDataTable({DT::datatable(dfbp1(), rownames = FALSE,
                                                extensions = list(Responsive = TRUE, 
                                                FixedHeader = TRUE)
  )
  })
  
  dfbp2 <- eventReactive(c(input$click5, input$boxSalesRange1), {
    dfbp1() %>% dplyr::filter(Sales >= input$boxSalesRange1[1] & Sales <= input$boxSalesRange1[2]) # %>% View()
  })
  
  dfbp3 <- eventReactive(c(input$click5, input$range5a), {
    dfbp2() %>% dplyr::filter(lubridate::year(Order_Date) == as.integer(input$range5a) & lubridate::quarter(Order_Date) == (4 * (input$range5a - as.integer(input$range5a))) + 1) %>% dplyr::arrange(desc(Order_Date)) # %>% View()
  })
    
  output$boxplotPlot1 <- renderPlotly({
    #View(dfbp3())
    p <- ggplot(dfbp3()) + 
      geom_boxplot(aes(x=Category, y=Sales, colour=Region)) + 
      ylim(0, input$boxSalesRange1[2]) +
      theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))
    ggplotly(p)
  })
  # End Box Plot Tab ___________________________________________________________
  
  # Begin Histgram Tab ------------------------------------------------------------------
  dfh1 <- eventReactive(input$click4, {
    if(online4() == "SQL") {
      print("Getting from data.world")
      query(
        data.world(propsfile = "www/.data.world"),
        dataset="cannata/superstoreorders", type="sql",
        query="select Shipping_Cost, Container
        from SuperStoreOrders
        where Container = 'Small Box'"
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "www/SuperStoreOrders.csv"
      df <- readr::read_csv(file_path)
      df %>% dplyr::select(Shipping_Cost, Container) %>% dplyr::filter(Container == 'Small Box') # %>% View()
    }
    })
  
  output$histogramData1 <- renderDataTable({DT::datatable(dfh1(), rownames = FALSE,
                                                  extensions = list(Responsive = TRUE, 
                                                  FixedHeader = TRUE)
  )
  })
  
  output$histogramPlot1 <- renderPlotly({p <- ggplot(dfh1()) +
      geom_histogram(aes(x=Shipping_Cost)) +
      theme(axis.text.x=element_text(angle=90, size=10, vjust=0.5))
      ggplotly(p)
  })
  # End Histogram Tab ___________________________________________________________
  
  # Begin Scatter Plots Tab ------------------------------------------------------------------
  dfsc1 <- eventReactive(input$click3, {
    if(online3() == "SQL") {
      print("Getting from data.world")
      query(
        data.world(propsfile = "www/.data.world"),
        dataset="cannata/superstoreorders", type="sql",
        query="select Sales, Profit, State
        from SuperStoreOrders
        where State = 'Texas' or State = 'Florida'"
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "www/SuperStoreOrders.csv"
      df <- readr::read_csv(file_path)
      df %>% dplyr::select(Sales, Profit, State) %>% dplyr::filter(State == 'Texas' | State == 'Florida') # %>% View()
    }
  })
  output$scatterData1 <- renderDataTable({DT::datatable(dfsc1(), rownames = FALSE,
                                                 extensions = list(Responsive = TRUE, 
                                                 FixedHeader = TRUE)
  )
  })
  output$scatterPlot1 <- renderPlotly({p <- ggplot(dfsc1()) + 
      theme(axis.text.x=element_text(angle=90, size=16, vjust=0.5)) + 
      theme(axis.text.y=element_text(size=16, hjust=0.5)) +
      geom_point(aes(x=Sales, y=Profit, colour=State), size=2)
      ggplotly(p)
  })
  # End Scatter Plots Tab ___________________________________________________________
  
# Begin Crosstab Tab ------------------------------------------------------------------
  dfct1 <- eventReactive(input$click1, {
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
  output$data1 <- renderDataTable({DT::datatable(dfct1(), rownames = FALSE,
                                extensions = list(Responsive = TRUE, FixedHeader = TRUE)
  )
  })
  output$plot1 <- renderPlot({ggplot(dfct1()) + 
    theme(axis.text.x=element_text(angle=90, size=16, vjust=0.5)) + 
    theme(axis.text.y=element_text(size=16, hjust=0.5)) +
    geom_text(aes(x=Category, y=State, label=sum_sales), size=6) +
    geom_tile(aes(x=Category, y=State, fill=kpi), alpha=0.50)
  })
# End Crosstab Tab ___________________________________________________________
# Begin Barchart Tab ------------------------------------------------------------------
  dfbc1 <- eventReactive(input$click2, {
    if(input$selectedRegions == 'All') region_list <- input$selectedRegions
    else region_list <- append(list("Skip" = "Skip"), input$selectedRegions)
    if(online2() == "SQL") {
      print("Getting from data.world")
      tdf = query(
        data.world(propsfile = "www/.data.world"),
        dataset="cannata/superstoreorders", type="sql",
        query="select Category, Region, sum(Sales) sum_sales
                from SuperStoreOrders
                where ? = 'All' or Region in (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                group by Category, Region",
        queryParameters = region_list
      ) # %>% View()
    }
    else {
      print("Getting from csv")
      file_path = "www/SuperStoreOrders.csv"
      df <- readr::read_csv(file_path)
      tdf = df %>% dplyr::filter(Region %in% input$selectedRegions | input$selectedRegions == "All") %>%
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
  output$barchartData1 <- renderDataTable({DT::datatable(dfbc1(),
                        rownames = FALSE,
                        extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  output$barchartData2 <- renderDataTable({DT::datatable(discounts,
                        rownames = FALSE,
                        extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  output$barchartData3 <- renderDataTable({DT::datatable(sales,
                        rownames = FALSE,
                        extensions = list(Responsive = TRUE, FixedHeader = TRUE) )
  })
  output$barchartPlot1 <- renderPlot({ggplot(dfbc1(), aes(x=Region, y=sum_sales)) +
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
      geom_hline(aes(yintercept = round(window_avg_sales)), color="red") +
      geom_text(aes( -1, window_avg_sales, label = window_avg_sales, vjust = -.5, hjust = -.25), color="red")
  })
  
  output$barchartMap1 <- renderLeaflet({leaflet(width = 400, height = 800) %>% 
    setView(lng = -98.35, lat = 39.5, zoom = 4) %>% 
    addTiles() %>% 
    addProviderTiles("MapQuestOpen.Aerial") %>%
    addMarkers(lng = discounts$Longitude,
      lat = discounts$Latitude,
      options = markerOptions(draggable = TRUE, riseOnHover = TRUE),
      popup = as.character(paste(discounts$Customer_Name, 
          ", ", discounts$City,
          ", ", discounts$State,
          " Sales: ","$", formatC(as.numeric(discounts$sumSales), format="f", digits=2, big.mark=","),
          " Discount: ", ", ", discounts$sumDiscount)) )
  })
  
  output$barchartPlot2 <- renderPlotly({
    # The following ggplotly code doesn't work when sumProfit is negative.
    p <- ggplot(sales, aes(x=as.character(Customer_Id), y=sumProfit)) +
      theme(axis.text.x=element_text(angle=0, size=12, vjust=0.5)) + 
      theme(axis.text.y=element_text(size=12, hjust=0.5)) +
      geom_bar(stat = "identity")
    ggplotly(p)
    # So, using plot_ly instead.
    plot_ly(
      data = sales,
      x = ~as.character(Customer_Id),
      y = ~sumProfit,
      type = "bar"
      ) %>%
      layout(
        xaxis = list(type="category", categoryorder="category ascending")
      )
  })
  # End Barchart Tab ___________________________________________________________
  
})
