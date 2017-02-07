FigureNum <<- 0 # Global variable

ggplot_func <- function(df,
  Title = "Diamonds",
  Legend = "color",   # Notice how this is handled below using the aes_string() function
  PointColor = c("red", "blue", "green", "yellow", "grey", "black", "purple"), # See https://groups.google.com/forum/#!forum/ggplot2 for color choices.
  Sizes = c(.5,.5,.5,.5,.5,.5,.5,.5),
  AxisSize = 12,
  TitleSize = 16,
  LegendSize = 14,
  YMin = 0,
  YMax = max(df$price) * 1.1,
  XMin = 0,
  XMax = max(df$carat) * 1.1,
  YLabel = 'price',
  XLabel = 'carat',
  Background = "grey97",
  MinorGridColor = "snow2",
  MajorGridColor = "snow3",
  MinorGridSize = .5,
  MajorGridSize = .5,
  FigNum = -1,
  FigNumOffset = 0
) {
  
    if(FigNum != -1) FigNum = FigNum
    else FigNum = {
      FigureNum <<- FigureNum + 1
    }
    
    names(df)[names(df) == Legend] <- 'Legend'
    
    p1 <- ggplot() + 
      coord_cartesian() + 
      scale_x_continuous(breaks=c(seq(XMin,XMax,by=1)), minor_breaks=seq(XMin,XMax,by=1))  + 
      #scale_x_discrete() +
      scale_y_continuous() +
      scale_y_discrete() +
      scale_colour_manual(values = PointColor) + # See http://docs.ggplot2.org/0.9.3.1/scale_manual.html for more information.
      scale_color_discrete(name=Legend) + # This is not on the ggplot Cheat Sheet by the way.
      #facet_wrap(~cut) +
      #facet_grid(clarity~cut, labeller=label_both) +
      labs(y = YLabel, x = paste(XLabel, '\nFigure', toString(FigNumOffset + FigNum)), title=Title) +
      ylim(YMin, YMax) + xlim(XMin, XMax) +
      # theme is now used, see http://docs.ggplot2.org/0.9.2.1/theme.html for more information.
      theme(legend.text = element_text(size = LegendSize, face = "bold")) + # see http://www.cookbook-r.com/Graphs/Legends_(ggplot2) for more information.
      theme(axis.text=element_text(size=12), axis.title=element_text(size=AxisSize,face="bold")) +
      theme(plot.title = element_text(size=TitleSize,face="bold")) +
      theme(panel.grid.major = element_line(colour=MajorGridColor, size=MajorGridSize)) +
      theme(panel.grid.minor = element_line(colour=MinorGridColor, size=MinorGridSize)) +
      theme(panel.background = element_rect(fill=Background, colour=Background)) +
      layer(data=df,  
            geom="point",
            params=list(), 
            # None of these worked for the following non-commented line:
            #mapping=aes(x = carat, y = price, color = Legend),
            #mapping=aes(x = carat, y = price, aes_string(color = Legend)),
            #mapping=aes(x = carat, y = price, color = substitute(Legend))
            # See http://stackoverflow.com/questions/32503843/using-a-function-parameter-in-ggplot-mapping-aes
            # I fixed it by doing the names(df)[names(df) == Legend] <- 'Legend' above.
            mapping=aes(x = carat, y = price, color = Legend), 
            stat="identity",
            #position=position_identity()
            position=position_jitter(width=0.3, height=0)
            #position=position_dodge()
      ) 
    return(p1)
}

p1 <- ggplot_func(diamonds)
p1
p2 <- ggplot_func(diamonds, YMin = 5000, YMax = 15000)
p2
p3 <- ggplot_func(subset(diamonds, cut == "Premium"), Legend = "cut")
p3
p4 <- ggplot_func(diamonds, Legend = "clarity", PointColor = c("red", "blue", "green", "yellow", "grey", "black", "purple", "orange"))
p4

library("grid")

# You may need to use getwd() to find out where the "4diamonds.png" file will be put.
# You can use setwd() to set the current working directory.
png("./RWorkshop/03 Grammar of Graphics with R & ggplot2/4diamonds.png", width = 25, height = 20, units = "in", res = 72)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))   

# Print Plots
print(p1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))  
print(p2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(p3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))  
print(p4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2)) 

dev.off()
