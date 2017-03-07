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
  df1 <- eventReactive(input$CLICKS1, {data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'localhost:5011/rest/native/?query=
    "select *
    from diamonds
    where cut = \'Fair\' or cut = \'Premium\';"
  ')), httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_UTEid', PASS='orcl_uteid', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE)))
  })
  
  # Begin code for First Tab:
  output$TABLE <- renderDataTable({DT::datatable(df1(), rownames = TRUE, extensions = list(Responsive = TRUE, FixedHeader = TRUE)
        )
    })
})
