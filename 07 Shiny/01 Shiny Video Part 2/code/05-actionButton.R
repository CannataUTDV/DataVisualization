# 05-actionButton

library(shiny)

ui <- fluidPage(
  actionButton(inputId = "E_CLICKS", 
    label = "Click me")
)

server <- function(input, output) {
  observeEvent(input$E_CLICKS, {
    print(as.numeric(input$E_CLICKS))
  })
}

shinyApp(ui = ui, server = server)
