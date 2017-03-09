# 02-tags.R

library(shiny)

ui <- fluidPage(
  tags$h1("My Shiny App"),
  tags$p(style = "font-family:Impact",
    "See other apps in the",
    tags$a("Shiny Showcase",
      href = "http://www.rstudio.com/
      products/shiny/shiny-user-showcase/")
  ),
  tags$img(height=100, width=100, src="bigorb.png"),
  HTML('<h1>HTML UT</h1>')
)

server <- function(input, output){}

shinyApp(ui = ui, server = server)
