# server.R
require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)
require(shiny)

shinyServer(function(input, output) {

  output$distPlot <- renderPlot({
  # Start your code here.

  # The following is equivalent to KPI Story 2 Sheet 2 and Parameters Story 3 in "Crosstabs, KPIs, Barchart.twb"
      
  KPI_Low_Max_value = input$KPI1     
  KPI_Medium_Max_value = input$KPI2
      
  df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
  "select color, clarity, sum_price, round(sum_carat) as sum_carat, kpi as ratio, 
  case
  when kpi < "p1" then \'03 Low\'
  when kpi < "p2" then \'02 Medium\'
  else \'01 High\'
  end kpi
  from (select color, clarity, 
  sum(price) as sum_price, sum(carat) as sum_carat, 
  sum(price) / sum(carat) as kpi
  from diamonds
  group by color, clarity)
  order by clarity;"
  ')), httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_UTEid', PASS='orcl_uteid', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', p1=KPI_Low_Max_value, p2=KPI_Medium_Max_value), verbose = TRUE)))
      
# df <- diamonds %>% group_by(color, clarity) %>% summarize(sum_price = sum(price), sum_carat = sum(carat)) %>% mutate(ratio = sum_price / sum_carat) %>% mutate(kpi = ifelse(ratio <= KPI_Low_Max_value, '03 Low', ifelse(ratio <= KPI_Medium_Max_value, '02 Medium', '01 High'))) %>% rename(COLOR=color, CLARITY=clarity, SUM_PRICE=sum_price, SUM_CARAT=sum_carat, RATIO=ratio, KPI=kpi)
      
  plot <- ggplot() + 
        coord_cartesian() + 
        scale_x_discrete() +
        scale_y_discrete() +
        labs(title='Diamonds Crosstab\nSUM_PRICE, SUM_CARAT, SUM_PRICE / SUM_CARAT') +
        labs(x=paste("COLOR"), y=paste("CLARITY")) +
        layer(data=df, 
              mapping=aes(x=COLOR, y=CLARITY, label=SUM_PRICE), 
              stat="identity", 
              #stat_params=list(), 
              geom="text",
              params=list(color="black"), 
              position=position_identity()
        ) +
        layer(data=df, 
              mapping=aes(x=COLOR, y=CLARITY, fill=KPI), 
              stat="identity", 
              #stat_params=list(), 
              geom="tile",
              params=list(alpha=0.50), 
              position=position_identity()
        )

  # End your code here.
        return(plot)
  }) # output$distPlot
})
