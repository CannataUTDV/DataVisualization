# 06-observeEvent

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "E_NUM", 
    label = "Choose a number",
    min = 1, max = 100, value = 25),
  actionButton(inputId = "E_GO", 
    label = "Print Value")
)

server <- function(input, output) {
  
  # observe responds to the print button but not the slider:
  observeEvent(input$E_GO, {
  # observe responds to the print button and the slider:
  # observeEvent(c(input$E_GO,input$E_NUM) , {
    print(as.numeric(input$E_NUM))
  })
}

shinyApp(ui = ui, server = server)
