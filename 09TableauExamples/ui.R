#ui.R
require(shiny)
require(shinydashboard)
require(DT)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Crosstabs, KPIs, Parameters", tabName = "crosstab", icon = icon("dashboard")),
      menuItem("Barcharts, Table Calculations", tabName = "barchart", icon = icon("dashboard"))
    )
  ),
  dashboardBody(    
    tabItems(
      # Begin Crosstab tab content.
      tabItem(tabName = "crosstab",
        tabsetPanel(
            tabPanel("Data",  
              radioButtons("rb1", "Get data from:",
                c("SQL" = "SQL",
                  "CSV" = "CSV"), inline=T),
              sliderInput("KPI1", "KPI_Low:", 
                          min = 0, max = .1,  value = .1),
              sliderInput("KPI2", "KPI_Medium:", 
                          min = .1, max = .2,  value = .2),
              actionButton(inputId = "click1",  label = "To get data, click here"),
              hr(), # Add space after button.
              DT::dataTableOutput("data1")
            ),
            tabPanel("Crosstab", plotOutput("plot1", height=1000))
          )
        ),
      # End Crosstab tab content.
      # Begin Barchart tab content.
      tabItem(tabName = "barchart",
        tabsetPanel(
          tabPanel("Data",  
             radioButtons("rb2", "Get data from:",
                          c("SQL" = "SQL",
                            "CSV" = "CSV"), inline=T),
             uiOutput("regions2"), # See http://shiny.rstudio.com/gallery/dynamic-ui.html
             actionButton(inputId = "click2",  label = "To get data, click here"),
             hr(), # Add space after button.
             'Here is data for the "Barchart with Table Calculation" tab',
             hr(),
             DT::dataTableOutput("barchartData1"),
             hr(),
             'Here is data for the "High Discount Orders" tab',
             hr(),
             DT::dataTableOutput("barchartData2"),
             hr(),
             'Here is data for the "High Sales Customers" tab',
             hr(),
             DT::dataTableOutput("barchartData3")
          ),
          tabPanel("Barchart with Table Calculation", "Black = Sum of Sales per Region, Red = Average Sum of Sales per Category, and  Blue = (Sum of Sales per Region - Average Sum of Sales per Category)", plotOutput("barchartPlot1", height=1500)),
          tabPanel("High Discount Orders", leafletOutput("barchartMap1"), height=900 ),
          tabPanel("High Sales Customers", "TBD", plotOutput("barchartPlot2", height=700) )
        )
      )
      # End Barchart tab content.
    )
  )
)

