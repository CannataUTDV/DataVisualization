#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstab", tabName = "crosstab", icon = icon("dashboard")),
      menuItem("Barchart", tabName = "barchart", icon = icon("th")),
      menuItem("Blending", tabName = "blending", icon = icon("th")),
      menuItem("Map", tabName = "map", icon = icon("th")),
      menuItem("Table", tabName = "table", icon = icon("th"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "crosstab",
        actionButton(inputId = "light", label = "Light"),
        actionButton(inputId = "dark", label = "Dark"),
        sliderInput("KPI1", "KPI_Low_Max_value:", 
                    min = 1, max = 4750,  value = 4750),
        sliderInput("KPI2", "KPI_Medium_Max_value:", 
                    min = 4750, max = 5000,  value = 5000),
        textInput(inputId = "title", 
                  label = "Crosstab Title",
                  value = "Diamonds Crosstab\nSUM_PRICE, SUM_CARAT, SUM_PRICE / SUM_CARAT"),
        actionButton(inputId = "clicks1",  label = "Click me"),
        plotOutput("distPlot1")
      ),
      
      # Second tab content
      tabItem(tabName = "barchart",
        actionButton(inputId = "clicks2",  label = "Click me"),
        plotOutput("distPlot2")
      ),
      
      # Third tab content
      tabItem(tabName = "blending",
        actionButton(inputId = "clicks3",  label = "Click me"),
        plotOutput("distPlot3")
      ),
      
      # Fourth tab content
      tabItem(tabName = "map",
        leafletOutput("map")
      ),
        
      # Fifth tab content
      tabItem(tabName = "table",
        dataTableOutput("table")
      )
    )
  )
)
  