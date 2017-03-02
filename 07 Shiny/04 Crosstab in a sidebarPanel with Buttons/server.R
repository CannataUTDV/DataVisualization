# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output) {
        
      KPI_Low_Max_value <- reactive({input$KPI1})     
      KPI_Medium_Max_value <- reactive({input$KPI2})
      rv <- reactiveValues(alpha = 0.50)
      observeEvent(input$light, { rv$alpha <- 0.50 })
      observeEvent(input$dark, { rv$alpha <- 0.75 })
    
      df <- eventReactive(input$clicks, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
            "select color, clarity, sum_price, round(sum_carat) as sum_carat, kpi as ratio, 
            case
            when kpi < "p1" then \\\'03 Low\\\'
            when kpi < "p2" then \\\'02 Medium\\\'
            else \\\'01 High\\\'
            end kpi
            from (select color, clarity, 
            sum(price) as sum_price, sum(carat) as sum_carat, 
            sum(price) / sum(carat) as kpi
            from diamonds
            group by color, clarity)
            order by clarity;"
            ')), httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_UTEid', PASS='orcl_uteid', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', p1=KPI_Low_Max_value(), p2=KPI_Medium_Max_value()), verbose = TRUE)))
      })

      output$distPlot <- renderPlot({             
            plot <- ggplot() + 
                  coord_cartesian() + 
                  scale_x_discrete() +
                  scale_y_discrete() +
                  labs(title=isolate(input$title)) +
                  labs(x=paste("COLOR"), y=paste("CLARITY")) +
                  layer(data=df(), 
                        mapping=aes(x=COLOR, y=CLARITY, label=SUM_PRICE), 
                        stat="identity", 
                        geom="text",
                        params=list(colour="black"), 
                        position=position_identity()
                  ) +
                  layer(data=df(), 
                        mapping=aes(x=COLOR, y=CLARITY, fill=KPI), 
                        stat="identity", 
                        geom="tile",
                        params=list(alpha=rv$alpha), 
                        position=position_identity()
                  )
            plot
      }) 

      observeEvent(input$clicks, {
            print(as.numeric(input$clicks))
      })
})
