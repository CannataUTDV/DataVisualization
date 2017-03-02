# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)
require(shinydashboard)
require(leaflet)
require(DT)

shinyServer(function(input, output) {
        
      KPI_Low_Max_value <- reactive({input$KPI1})     
      KPI_Medium_Max_value <- reactive({input$KPI2})
      rv <- reactiveValues(alpha = 0.50)
      observeEvent(input$light, { rv$alpha <- 0.50 })
      observeEvent(input$dark, { rv$alpha <- 0.75 })
    
      df1 <- eventReactive(input$clicks1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
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

# Begin code for First Tab:
      output$table <- renderDataTable({DT::datatable(df1(), rownames = TRUE,
            extensions = list(
                        # The following statement is commented out because it doesn't seem to work properly.
                          # AutoFill = list(columnDefs = list(list(enable = FALSE, targets = c(0, 1, -1, -2)), list(increment = TRUE, targets = c(3, 4)))),
                          Responsive = TRUE,
                          FixedHeader = TRUE
                        # To get the functionality in the following 3 statements, uncomment the statement and the corresponding options statement below, 
                        # also comment the TableTools = TRUE statement and the last options statement.
                          # ColReorder = TRUE  
                          # ColVis = TRUE       
                          # FixedColumns = TRUE 
                          #TableTools = TRUE
                     ), 
            #options = list(order = list(list(1, 'asc'), list(3, 'desc')), dom='Rlfrtip')
            # options = list(order = list(list(1, 'asc'), list(3, 'desc')), dom='C<"clear">lfrtip')
            # options = list(dom = 't', scrollX = TRUE, scrollCollapse = TRUE)
            #options = list(dom = 'T<"clear">lfrtip', tableTools = list(sSwfPath = copySWF('www', pdf = TRUE)))
        )
      })
})
