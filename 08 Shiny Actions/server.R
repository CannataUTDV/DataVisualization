require(dplyr)

x=1:5
y=2*x
z=c('a', 'b', 'c', 'd', 'e')
df=data.frame(x,y, z)
print(df)

server <- function(input, output) {
  output$plot1 <- renderPlot({
    ggplot(df) + geom_point(aes(x=x, y=y, colour=z, size=4)) + guides(size=FALSE)
  })
  
  output$plot2 <- renderPlot({
    brush = brushOpts(id="plot_brush", delayType = "throttle", delay = 30)
    bdf=brushedPoints(df, input$plot_brush)
    View(bdf)
    if( !is.null(input$plot_dblclick) ) {
      print("Saw a double click")
      print(input$plot_dblclick)
      pdf=NULL
      input$plot_dblclick=NULL
    } else if( !is.null(input$plot_brush) ) {
      pdf = df %>% dplyr::filter(x %in% bdf[, "x"])
    } else pdf = NULL
    ggplot(pdf) + geom_point(aes(x=x, y=y, colour=z, size=4)) + guides(size=FALSE)
      #df %>% dplyr::filter(x == round(input$plot_click$xmin, 0)) %>% ggplot() + geom_point(aes(x=x, y=y))
    #df %>% dplyr::filter(x == round(input$plot_dblclick$x, 0)) %>% ggplot() + geom_point(aes(x=x, y=y))
    #df %>% dplyr::filter(x == round(input$plot_hover$x, 0)) %>% ggplot() + geom_point(aes(x=x, y=y))
  })
}

