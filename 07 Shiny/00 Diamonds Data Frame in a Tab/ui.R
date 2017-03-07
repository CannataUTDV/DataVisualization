#ui.R 

require(shiny)
require(DT)

navbarPage(
  title = "Elements of Data Visualization",
  tabPanel(title = "Diamonds Data",
     sidebarPanel(
       actionButton(inputId = "CLICKS1",  label = "Click me")
     ),
     
     mainPanel(dataTableOutput("TABLE")
     )
  )
)
