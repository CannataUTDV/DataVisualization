# 03-reactive

library(shiny)

ui <- fluidPage(
  sliderInput(inputId = "E_NUM", 
    label = "Choose a number", 
    value = 25, min = 1, max = 100),
  plotOutput("O_HIST"),
  verbatimTextOutput("O_STATS")
)

server <- function(input, output) {
  
  data <- reactive({
    rnorm(input$E_NUM)
  })
  print(class(data))
  
  output$O_HIST <- renderPlot({
    hist(data()) # You need to do data() and not data
  })
  output$O_STATS <- renderPrint({
    summary(data()) # You need to do data() and not data
  })
}

shinyApp(ui = ui, server = server)
