# 02-two-outputs

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "E_NUM", 
    label = "Choose a number", 
    value = 25, min = 1, max = 100),
  plotOutput("O_HIST"),
  verbatimTextOutput("O_STATS")
)

server <- function(input, output) {
  output$O_HIST <- renderPlot({
    hist(rnorm(input$E_NUM))
  })
  output$O_STATS <- renderPrint({
    summary(rnorm(input$E_NUM))
  })
}

shinyApp(ui = ui, server = server)
