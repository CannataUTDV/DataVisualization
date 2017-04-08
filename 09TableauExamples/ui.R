#ui.R

require(shiny)
require(shinydashboard)

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
        sliderInput("KPI1", "KPI_Low:", 
                    min = 0, max = .1,  value = .1),
        sliderInput("KPI2", "KPI_Medium:", 
                    min = .1, max = .2,  value = .2),
        actionButton(inputId = "click1",  label = "To start, click here"),
        plotOutput("distPlot1", height=1000)
      )
    )
  )
)
  
