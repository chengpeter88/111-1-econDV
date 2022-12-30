library(HistData)
library(tidyr)
library(ggplot2)
library(svglite)
N=Nightingale[ c("Date","Year","Disease.rate","Wounds.rate","Other.rate")]
N.pivot=pivot_longer(
  data=N, cols=c("Disease.rate","Wounds.rate","Other.rate"),
  names_to="cause",
  values_to="death_rate"
  )
g=ggplot(data=N.pivot,aes(x=factor(Date),y=death_rate,fill=cause))+ggtitle("death rate in the crimea(apr,1854~mar,1856)" )+xlab("Date")+ylab("Death Rate")+theme(axis.text.x = element_text(color = "#111111",size=10, face="bold") ,axis.title.x=element_text(angle = 90))

g=g+geom_bar(width = 1,stat = "identity",position = "stack",colours="black")
g=g+geom_text(data=N.pivot, mapping=aes(x=factor(Date),y=death_rate,label=death_rate),check_overlap = TRUE,
            angle=45,
            colors="blue",
            size=3,
            vjust=0.5
            )
g=g+scale_y_sqrt()
g=g+coord_polar(start = pi,clip = "on")
g

ggsave(file="/Users/heng/Desktop/python 1/111-1-econDV/rose_Nsqurt.svg", g,scale=2)

