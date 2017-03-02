require("jsonlite")
require("RCurl")
require("ggplot2")
require("dplyr")

getwd()
if(! grepl('Data Wrangling', getwd())) setwd("./RWorkshop/05 Data Wrangling")

experimentID = 10029
df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'oraclerest.cs.utexas.edu:5001/rest/native/?query=
"SELECT * 
from timeseries 
where eid = "e""
')),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_UTEid', PASS='orcl_uteid', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON', e=experimentID), verbose = TRUE), ))

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  facet_wrap(~ NAME, ncol = 2) +
  theme_grey() +
  theme(text = element_text(size=20)) +
  labs(title=paste('Exp', experimentID, 'Obytes/second (i.e., obytes - previous obytes) vs. time')) +
  labs(x="Time (i.e., snaptime - min(snaptime))", y="Obytes/second") +
  guides(size=FALSE) +
  
  layer(data=df,  
        geom = "line",
        params = list(size = 2),
        mapping=aes(x=SNAPTIME, y=OBYTES, color=NAME, size='1'),
        stat="identity", 
        position=position_identity()
  )

n <- df %>% distinct(NAME)
class(n)
names = sort(n[,1])
class(names)
e <- df %>% distinct(EID)
eid = e[,1]

require("grid")

file <- paste("Timeseries_", eid, ".png",  sep="")
png(file, width = 20, height = 12, units = "in", res = 72)
grid.newpage()
pushViewport(viewport(layout = grid.layout(4, 1)))   

plotNum = 1
for(i in names){
  if(grepl('data$', i)) next
  #if(grepl('phys', i)) next
  print(i)
  
  df1 = dplyr::filter(df, grepl(i, NAME)) # Gives rows for one name
  
  df2 = df1[with(df1, order(NAME, SNAPTIME)), ] # Sort the rows by name and then snaptime
  
  df3 = dplyr::mutate(df2, before = lag(OBYTES), throughput = (OBYTES - lag(OBYTES)), time = SNAPTIME - min(SNAPTIME))
  maxTime = max(df3$time)
  
  df4 = dplyr::filter(df3, throughput < 10000000000 & throughput >= 0)
  
  plot = ggplot() + 
    coord_cartesian() + 
    scale_x_continuous(minor_breaks = seq(0 , maxTime, 1), breaks = seq(0, maxTime, 10)) +
    scale_y_continuous() +
    facet_wrap(~ NAME, ncol = 2) +
    theme_grey() +
    theme(text = element_text(size=20)) +
    theme(panel.grid.minor = element_line(colour="black", size=0.5)) +
    labs(title=paste('Exp', eid, 'Obytes/second (i.e., obytes - previous obytes) vs. time')) +
    labs(x="Time (i.e., snaptime - min(snaptime))", y="Obytes/second") +
    guides(size=FALSE) +
    
    layer(data=df4,  
          geom = "line",
          params = list(size = 2),
          mapping=aes(x=time, y=throughput, color=NAME, size='1'),
          stat="identity", 
          position=position_identity()
    )
  print(plot, vp = viewport(layout.pos.row = plotNum, layout.pos.col = 1)) 
  plotNum = plotNum + 1
}

dev.off()
