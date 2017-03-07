# 08-reactiveValues

library(shiny)

ui <- fluidPage(
  actionButton(inputId = "E_NORM", label = "Normal"),
  actionButton(inputId = "E_UNIF", label = "Uniform"),
  plotOutput("O_HIST")
)

server <- function(input, output) {

  rv <- reactiveValues(data = rnorm(100))

  observeEvent(input$E_NORM, { rv$data <- rnorm(100) })
  observeEvent(input$E_UNIF, { rv$data <- runif(100) })

  output$O_HIST <- renderPlot({ 
    hist(rv$data) 
  })
}

shinyApp(ui = ui, server = server)
