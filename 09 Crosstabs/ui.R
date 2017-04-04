#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstab", tabName = "crosstab", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "crosstab",
        sliderInput("KPI1", "KPI_Low_Max_value:", 
                    min = 1, max = 4750,  value = 4750),
        sliderInput("KPI2", "KPI_Medium_Max_value:", 
                    min = 4750, max = 5000,  value = 5000),
        actionButton(inputId = "clicks1",  label = "To start, click here"),
        plotOutput("distPlot1")
      )
    )
  )
)
  
