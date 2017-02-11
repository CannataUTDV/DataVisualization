require(tidyr)
require(dplyr)
require(ggplot2)

FigureNum <<- 0 # Global variable

ggplot_func <- function(df,
  Title = "Diamonds",
  Legend = "color",   # Notice how this is handled below using names(df)[names(df) == Legend] <- 'Legend'
  PointColor = c("red4", "darkslategray3", "dodgerblue1", "darkcyan",
                 "gray79", "black", "skyblue2", "dodgerblue4",
                 "purple4", "maroon", "chocolate1", "bisque3", "bisque",
                 "seagreen4", "lightgreen", "skyblue4", "mediumpurple3",
                 "palevioletred1", "lightsalmon4", "darkgoldenrod1"),
  YMin = 0,
  YMax = max(df$price) * 1.1,
  XMin = 0,
  XMax = max(df$carat) * 1.1,
  Caption = ""
) {
    FigureNum <<- FigureNum + 1
    
    # See http://stackoverflow.com/questions/32503843/using-a-function-parameter-in-ggplot-mapping-aes for a discussion of the following line of code:
    names(df)[names(df) == Legend] <- 'Legend'
    print(names(df))
    
    p <- ggplot(df) + 
      geom_point(aes(x=carat, y=price, colour=Legend)) +
      ylim(YMin, YMax) + xlim(XMin, XMax) +
      scale_colour_manual(values = PointColor) +
      labs(title="Grammar of Graphics Example", x = paste("carat\nFigure ", FigureNum), colour = Legend, caption = Caption) +
      theme(axis.text.x=element_text(size=20, vjust=0.5)) +
      theme(axis.text.y=element_text(size=20, hjust=0.5)) +
      theme(plot.title = element_text(size=22)) +
      theme(legend.title = element_text(size=20, face="bold"), legend.text = element_text(size=18))
 
    return(p)
}

p1 <- ggplot_func(diamonds)
p2 <- ggplot_func(diamonds, YMin = 5000, YMax = 15000, Caption = "This is a subset of the previous figure's  data")
p3 <- dplyr::filter(diamonds, cut == "Premium") %>% ggplot_func(., Legend = "cut")
p4 <- ggplot_func(diamonds, Legend = "clarity", PointColor = c("black", "purple", "red", "blue", "green", "yellow", "grey", "orange"))

require("grid")

# You may need to use getwd() to find out where the "4diamonds.png" file will be put.
# You can use setwd() to set the current working directory.
png("4diamonds.png", width = 25, height = 20, units = "in", res = 72)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))   

# Print Plots
print(p1, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))  
print(p2, vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(p3, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))  
print(p4, vp = viewport(layout.pos.row = 2, layout.pos.col = 2)) 

dev.off()
