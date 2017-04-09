#ui.R

require(shiny)
require(shinydashboard)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstabs, KPIs, Parameters", tabName = "crosstab", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
        tabItem(tabName = "crosstab",  
        radioButtons("rb", "Choose one:",
          c("SQL" = "SQL",
            "CSV" = "CSV")),
        sliderInput("KPI1", "KPI_Low:", 
                    min = 0, max = .1,  value = .1),
        sliderInput("KPI2", "KPI_Medium:", 
                    min = .1, max = .2,  value = .2),
        actionButton(inputId = "click1",  label = "To start, click here"),
        plotOutput("plot1", height=1000)
      )
    )
  )
)
  
