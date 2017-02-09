require(tidyr)
require(ggplot2)

options(java.parameters="-Xmx2g")

'
Grammar of Graphics Example:
ggplot(data = diamonds) +
   geom_point(aes(x=cut, y=price, colour=as.character(carat))) +
   #facet_grid(~clarity) +
   #facet_grid(clarity~cut, labeller=label_both) +
   #theme_classic() +
   #theme(axis.ticks.y=element_blank(), axis.text.y=element_blank()) +
   theme(axis.text.x=element_text(angle=50, size=10, vjust=0.5)) +
   labs(title="Grammar of Graphics Example")

Another Example:
x=c(1,2,3,4,5); y=x*2; z=x^3; df = data.frame(x,y,z)
ggplot(data=df) + geom_point(aes(x=x, y=y))
ggplot(data=df) + geom_point(aes(x=x, y=z))
tidyr::gather(df, variable, value, -x) %>% ggplot() + geom_point(aes(x=x, y=value, colour = variable, size=4)) + geom_line(aes(x=x, y=value, colour = variable))
'

# Run an example:
x=c(1,2,3,4,5); y=x*2; z=x^3; df = data.frame(x,y,z)
plot = tidyr::gather(df, variable, value, -x) %>% ggplot() + geom_point(aes(x=x, y=value, colour = variable, size=4)) + geom_line(aes(x=x, y=value, colour = variable))
print(plot)
