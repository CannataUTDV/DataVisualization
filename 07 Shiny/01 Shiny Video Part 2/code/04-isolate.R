# 04-isolate

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "E_NUM", 
    label = "Choose a number", 
    value = 25, min = 1, max = 100),
  textInput(inputId = "E_TITLE", 
    label = "Write a title",
    value = "Histogram of Random Normal Values"),
  plotOutput("O_HIST")
)

server <- function(input, output) {
  output$O_HIST <- renderPlot({
    hist(rnorm(input$E_NUM), main = isolate(input$E_TITLE))
  })
}

shinyApp(ui = ui, server = server)
