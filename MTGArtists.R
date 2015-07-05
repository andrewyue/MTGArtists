# load required libraries
library(ggplot2)
library(grid)
library(gridExtra)
library(extrafont)
library(scales)
library(reshape2)
# load in allcards.txt
allcards <- read.delim("~/MTGArtists/allcards.txt", header=TRUE)
# establish basic land names and sets in which all basic lands are known reprints
basiclands = c('Plains', 'Island', 'Swamp', 'Forest', 'Mountain')
repeatedbasicset = c('Limited Edition Beta', 'Unlimited Edition', 'Revised Edition', 'Fourth Edition', 'Ninth Edition')
# set up order of card colors/types
colororder = c('White', 'Blue', 'Black', 'Green', 'Red', 'Multi', 'Colorless', 'Land')
# and assign plot colors to each
cols = c('White' = 'ivory', 'Blue' = 'lightskyblue', 'Black' = 'gray58', 'Green' = 'springgreen3', 'Red' = 'indianred1', 'Colorless' = 'tan3', 'Multi' = 'gold', 'Land' = 'slateblue4')
# generate a TRUE/FALSE column containing any repeated combinations of card name + artist
allcards$repeatname = duplicated(allcards[1:2])
# generate a TRUE/FALSE column containing all basic lands
allcards$isbasicland = allcards$cardname %in% basiclands
# generate a TRUE/FALSE column that represents all basic lands and unique non-basic land cards
allcards$allbasicsandnonrepeats = !allcards$repeatname|allcards$isbasicland
# generate a TRUE/FALSE column that represents repeated basic from the list repeatedbasicset
allcards$repeatedbasic = allcards$set %in% repeatedbasicset
# generate a TRUE/FALSE column that combines unique non-basic land cards and basic lands not included in repeatedbasicset
allcards$uniquecard = allcards$allbasicsandnonrepeats & !allcards$repeatedbasic
# create a data frame including only the unique cards
uniquecards = subset(allcards, uniquecard == TRUE)
# determine the top artists by total number of cards attributed to them
topartists = as.character(stack(summary(uniquecards$artist)))
topartists = stack(summary(uniquecards$artist))
# determine the top ten from this list
top10artists = as.character(topartists$ind[1:10])
# and make a new data frame containing cards attributable to the top ten artists
top10uniques = subset(uniquecards, artist %in% top10artists)
top10uniques$artist = factor(top10uniques$artist, levels = top10artists)
top10uniques$color = factor(top10uniques$color, levels = colororder)
# trickery to allow for a facet_wrap with relative percentages for individual artists instead of the top ten combined
df = aggregate(color~artist,top10uniques, function(x)c(White=100*sum(x=="White")/length(x), Blue=100*sum(x=="Blue")/length(x), Black=100*sum(x=="Black")/length(x), Green=100*sum(x=="Green")/length(x), Red=100*sum(x=="Red")/length(x), Multi=100*sum(x=="Multi")/length(x), Colorless=100*sum(x=="Colorless")/length(x), Land=100*sum(x=="Land")/length(x)))
df = data.frame(artist=df$artist, df$color)
gg = melt(df,id=1, variable.name="Color",value.name="Rel.Pct.")
# slightly modified version of theme found here: http://jonlefcheck.net/2013/03/11/black-theme-for-ggplot2-2/
theme_black=function(base_size=12,base_family="") {
  theme_grey(base_size=base_size,base_family=base_family) %+replace%
    theme(
      # Specify axis options
      axis.line=element_blank(), 
      axis.text.x=element_text(size=base_size*1.2,color="white",
                               lineheight=0.9,vjust=1), 
      axis.text.y=element_text(size=base_size*1.2,color="white",
                               lineheight=0.9,hjust=1), 
      axis.ticks=element_line(color="white",size = 0.2), 
      axis.title.x=element_text(size=base_size,color="white",vjust=1), 
      axis.title.y=element_text(size=base_size*1.2,color="white",angle=90,
                                vjust=0.5), 
      axis.ticks.length=unit(0.3,"lines"), 
      axis.ticks.margin=unit(0.5,"lines"),
      # Specify legend options
      legend.background=element_rect(color=NA,fill="black"), 
      legend.key=element_rect(color="white", fill="black"), 
      legend.key.size=unit(1.2,"lines"), 
      legend.key.height=NULL, 
      legend.key.width=NULL,     
      legend.text=element_text(size=base_size*0.8,color="white"), 
      legend.title=element_text(size=base_size*0.8,face="bold",hjust=0,
                                color="white"), 
      legend.position="bottom", 
      legend.text.align=NULL, 
      legend.title.align=NULL, 
      legend.direction="horizontal", 
      legend.box=NULL,
      # Specify panel options
      panel.background=element_rect(fill="black",color = NA), 
      panel.border=element_rect(fill=NA,color="white"), 
      panel.grid.major=element_line(color='gray50',size=0.2), 
      panel.grid.minor=element_blank(), 
      panel.margin=unit(0.5,"lines"),  
      # Specify facetting options
      strip.background=element_rect(fill="grey30",color="grey10"), 
      strip.text.x=element_text(size=base_size*0.8,color="white"), 
      strip.text.y=element_text(size=base_size*0.8,color="white",
                                angle=-90), 
      # Specify plot options
      plot.background=element_rect(color="black",fill="black"), 
      plot.title=element_text(size=base_size*1.2,color="white"), 
      plot.margin=unit(c(1.5,1,0.25,0.25),"lines")
    )
}
# grotesque ggplots for the top 10 artist relative percentages by card color/type
top10percentages = ggplot(gg) + geom_bar(aes(x=Color, y=Rel.Pct., fill=Color),position="dodge",stat="identity")+facet_wrap(~artist,nrow=1, ncol=10) + scale_fill_manual(values = cols)+ scale_x_discrete(breaks=NULL) + xlab(NULL) + ylab('Distribution by Card Color (%)') + theme_black() + theme(plot.margin=unit(c(0,0.5,0,1.5),"lines"),strip.text.x = element_blank(),strip.background=element_blank())+coord_cartesian(ylim=c(0,75))+theme(axis.text.y = element_text(size=32, family="Myriad Web Pro"),axis.title.y = element_text(size=32, family="MPlantin",vjust=3)) + theme(legend.text=element_text(size=24,color="white",family="MPlantin"), legend.title=element_text(size=24,face="bold",hjust=0,color="white",family="MPlantin"))
# and total pieces of artwork
top10totals = ggplot(top10uniques, aes(artist, fill=color)) + geom_bar(width=900) + xlab(NULL) + ylab('Total Pieces') + theme_black() + scale_fill_manual(values = cols) + facet_wrap(~artist, ncol=10, nrow=1) + theme(strip.background=element_blank()) + scale_x_discrete(breaks=NULL) + coord_cartesian(ylim=c(0,405)) + theme(plot.margin=unit(c(0,0.5,0,1.5),"lines")) + theme(strip.text.x = element_text(size=28,family="MPlantin")) +theme(axis.text.y = element_text(size=32, family="Myriad Web Pro"),axis.title.y = element_text(size=32, family="MPlantin",vjust=3))+theme(legend.position='none')+theme(plot.title = element_text(size=54, family="MPlantin"))+ggtitle('Most Prolific Magic the Gathering Artists\n')
# combined into a grid
totals <- ggplotGrob(top10totals)
percentages <- ggplotGrob(top10percentages)
maxWidth = grid::unit.pmax(totals$widths[2:5], percentages$widths[2:5])
totals$widths[2:5] <- as.list(maxWidth)
percentages$widths[2:5] <- as.list(maxWidth)
grid.arrange(totals, percentages, ncol=1)
