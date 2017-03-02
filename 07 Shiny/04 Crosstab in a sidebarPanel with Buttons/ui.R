#ui.R 

library(shiny)

shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Hello Shiny!"),

  # Sidebar with a slider input for number of observations
    sidebarPanel(
      actionButton(inputId = "light", label = "Light"),
      actionButton(inputId = "dark", label = "Dark"),
      sliderInput("KPI1", 
                  "KPI_Low_Max_value:", 
                  min = 1,
                  max = 4750, 
                  value = 4750),
      sliderInput("KPI2", 
                  "KPI_Medium_Max_value:", 
                  min = 4750,
                  max = 5000, 
                  value = 5000),
      textInput(inputId = "title", 
                label = "Crosstab Title",
                value = "Diamonds Crosstab\nSUM_PRICE, SUM_CARAT, SUM_PRICE / SUM_CARAT"),
      actionButton(inputId = "clicks", 
                   label = "Click me")
    ),

  # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
))
