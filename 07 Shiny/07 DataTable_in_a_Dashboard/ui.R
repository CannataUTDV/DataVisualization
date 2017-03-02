#ui.R 

require(shiny)
require(shinydashboard)
require(leaflet)
require(DT)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("DataTable", tabName = "datatable", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "datatable",
              actionButton(inputId = "light", label = "Light"),
              actionButton(inputId = "dark", label = "Dark"),
              sliderInput("KPI1", "KPI_Low_Max_value:", 
                          min = 1, max = 4750,  value = 4750),
              sliderInput("KPI2", "KPI_Medium_Max_value:", 
                          min = 4750, max = 5000,  value = 5000),
              textInput(inputId = "title", 
                        label = "DataTable Title",
                        value = "Diamonds Crosstab\nSUM_PRICE, SUM_CARAT, SUM_PRICE / SUM_CARAT"),
              actionButton(inputId = "clicks1",  label = "Click me"),
              dataTableOutput("table")
      )
    )
  )
)

