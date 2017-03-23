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
    if( !is.null(input$plot_brush) ) {
      df %>% dplyr::filter(x %in% bdf[, "x"]) %>% ggplot() + geom_point(aes(x=x, y=y, colour=z, size=4)) + guides(size=FALSE)
    } 
  })
}

