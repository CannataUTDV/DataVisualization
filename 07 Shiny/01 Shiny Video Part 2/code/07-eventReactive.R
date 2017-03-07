# 07-eventReactive

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "E_NUM", 
    label = "Choose a number", 
    value = 25, min = 1, max = 100),
  actionButton(inputId = "E_GO", 
    label = "Update"),
  plotOutput("O_HIST")
)

server <- function(input, output) {
  data <- eventReactive(input$E_GO, {
    rnorm(input$E_NUM) 
  })
  
  output$O_HIST <- renderPlot({
    hist(data())
  })
}

shinyApp(ui = ui, server = server)
