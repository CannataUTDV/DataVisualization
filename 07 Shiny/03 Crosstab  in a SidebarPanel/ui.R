#ui.R 

library(shiny)
require(shinydashboard)

shinyUI(pageWithSidebar(

# Application title
headerPanel("Hello Shiny!"),

# Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("KPI1", 
                "KPI_Low_Max_value:", 
                min = 1,
                max = 4750, 
                value = 4750),
    sliderInput("KPI2", 
                "KPI_Medium_Max_value:", 
                min = 4750,
                max = 5000, 
                value = 5000)
  ),
# Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot")
    #plotOutput("distTable")
  )
))
