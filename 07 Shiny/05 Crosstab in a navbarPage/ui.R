#ui.R 

library(shiny)

navbarPage(
  title = "Elements of Visualization",
  tabPanel(title = "Crosstab",
     sidebarPanel(
       actionButton(inputId = "light", label = "Light"),
       actionButton(inputId = "dark", label = "Dark"),
       sliderInput("KPI1", "KPI_Low_Max_value:", 
                   min = 1, max = 4750,  value = 4750),
       sliderInput("KPI2", "KPI_Medium_Max_value:", 
                   min = 4750, max = 5000,  value = 5000),
       textInput(inputId = "title", 
                 label = "Crosstab Title",
                 value = "Diamonds Crosstab\nSUM_PRICE, SUM_CARAT, SUM_PRICE / SUM_CARAT"),
       actionButton(inputId = "clicks1",  label = "Click me")
     ),
     
     mainPanel(plotOutput("distPlot1")
     )
  ),
  tabPanel(title = "Barchart",
     sidebarPanel(
       actionButton(inputId = "clicks2",  label = "Click me")
     ),
     
     mainPanel(plotOutput("distPlot2")
     )
  ),
  tabPanel(title = "Blending 2 Data Sources",
     sidebarPanel(
       actionButton(inputId = "clicks3",  label = "Click me")
     ),
     
     mainPanel(plotOutput("distPlot3")
     )        
  )
)
  