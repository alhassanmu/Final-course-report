#### ggplot excersize

#### check you have these packages installed.
# if not, use the following command: install.packages("name.of.package")

library(ggplot2)
library(dplyr)
library(tidyr)
library(broom)
library(grid)
library(cowplot)
library(corrplot)
library(Hmisc)
library(ARTool)
library(EBImage)


# you probably do not have the last one installed. for that one, use the following command:

#if (!require("BiocManager", quietly = TRUE))
#install.packages("BiocManager")

#BiocManager::install("EBImage")



####




#### get the data
# download the data to your computer and place it in a designated folder.
# copy the path to the folder
# set a working directory

setwd("C:/Users/user/Desktop/Methods/ggplot") #(you change it to the path to your folder)

#### load the data. see that we use "stringsAsFactors=TRUE" so our groups are already set as factors.
pi_data=read.csv("course_pi_curve_pars_NLS_fixedparms.csv", header=TRUE, stringsAsFactors = TRUE)
str(pi_data)

library(ggplot2)
ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group))

#change size of the points
ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group), size=3)

#annotate groups by shape

ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(shape=Group), size=3)

# use both shape and size to anotate groups
ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)

# select the shapes you want
# R shapes: https://subscription.packtpub.com/book/data/9781788398312/2/ch02lvl1sec16/plotting-a-shape-reference-palette-for-ggplot2
ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_shape_manual(values=c(21, 22))

# use fill instead of color
ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(fill=Group, shape=Group), size=3)+
  scale_shape_manual(values=c(21, 22))

# select the fill colors you want
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(fill=Group, shape=Group), size=3)+
  scale_shape_manual(values=c(21, 22))+
  scale_fill_manual(values=c("green", "red"))

# select the colors you want
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf

ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))


# desigh the overall theme
ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme_bw()

ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme_classic()


ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme(text = element_text(size=20))


ggplot(pi_data, aes(x=Group, y=Am))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme_light()


#### all of them together

# first we have to turn the table from 'wide' to 'long' format
str(pi_data)


pi_data_long=reshape2::melt(pi_data, id.vars=list("sample.ID", "Group"),
                            measure.vars=list("Am", "AQY", "Rd", "Ik"))

head(pi_data_long)

colnames(pi_data_long)= c("sample.ID", "Group", "variable", "Value")

ggplot(pi_data_long, aes(x=Group, y=Value))+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme_light()+
  facet_wrap(.~variable, nrow=2, scales="free")


#Let's try boxplot (NOTE: a boxplot is good for n>4.....)

ggplot(pi_data_long, aes(x=Group, y=Value))+
  geom_boxplot()+
  theme_light()+
  facet_wrap(.~variable, nrow=2, scales="free")

#lose the outlier signs

ggplot(pi_data_long, aes(x=Group, y=Value))+
  geom_boxplot(outlier.shape = NA)+
  theme_light()+
  facet_wrap(.~variable, nrow=2, scales="free")


# do both point and boxplot

ggplot(pi_data_long, aes(x=Group, y=Value))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme_light()+
  facet_wrap(.~variable, nrow=2, scales="free")

#let's give this plot a name:
plot1=ggplot(pi_data_long, aes(x=Group, y=Value))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(aes(color=Group, shape=Group), size=3)+
  scale_color_manual(values=c("green", "red"))+
  theme_light()+
  facet_wrap(.~variable, nrow=2, scales="free")

# now, a barplot with error bars will take some more work. NOTE: barplot is only correct for normal distribution data (which we do not know we have....)

# we will first calculate average and standard deviation for each variable for each group

library(dplyr)
library(tidyr)
str(pi_data_long)

# 
pi_data_long_stats=pi_data_long %>% 
  group_by(Group, variable) %>%
  dplyr::summarize(mean=mean(Value), sd=sd(Value))


pi_data_long_stats


#Now let us ggplot

plot2=ggplot(pi_data_long_stats, aes(x=Group, y=mean))+
  geom_bar(stat="identity", fill="grey70")+
  geom_errorbar(aes(ymin = mean-sd, ymax = mean+sd), position = "dodge", width=0.2)+
  facet_wrap(.~ variable, scales="free")+
  theme_light()

plot2

# if you want to be able to add significance in a graphic software, you may need to increase the maximum value of the y axis.
# this function will allow for that.

# 1) run the function 

#function starts here
scale_inidividual_facet_y_axes = function(plot, ylims) {
  init_scales_orig = plot$facet$init_scales
  
  init_scales_new = function(...) {
    r = init_scales_orig(...)
    # Extract the Y Scale Limits
    y = r$y
    # If this is not the y axis, then return the original values
    if(is.null(y)) return(r)
    # If these are the y axis limits, then we iterate over them, replacing them as specified by our ylims parameter
    for (i in seq(1, length(y))) {
      ylim = ylims[[i]]
      if(!is.null(ylim)) {
        y[[i]]$limits = ylim
      }
    }
    # Now we reattach the modified Y axis limit list to the original return object
    r$y = y
    return(r)
  }
  
  plot$facet$init_scales = init_scales_new
  
  return(plot)
} ## here the function ends



# 2) determine the limits you want for each facet of the graph
ylims = list(c(0,120), c(0, 0.4), c(-3.5,1.5), c(0, 600))

# 3) add the new y limits to your plot

scale_inidividual_facet_y_axes(plot2, ylims = ylims)

# EXPORT AS SVG

#### now, we need to add another part of the figure, which is an image (.png format)

#if (!require("BiocManager", quietly = TRUE))
#install.packages("BiocManager")

#BiocManager::install("EBImage")

library(EBImage)
img = readImage("pi_photo.png")
display(img, method = "raster")


library(ggplot2)
library(grid)
library(cowplot)
g <- rasterGrob(img, interpolate = TRUE)


plot_grid(g, plot1, labels = "AUTO")

  

#### STATISTIS....

# to test the data, we use the Wilcoxon two samples test (= Mann-Whitney)
# you can do it for each one separately

str(pi_data)
wilcox.test(Am ~ Group, data=pi_data, paired=FALSE)
wilcox.test(AQY ~ Group, data=pi_data, paired=FALSE)

# or, using the long table format, do it for the whole bunch         

res <- pi_data_long %>% group_by(variable) %>% 
  do(w = wilcox.test(Value~Group, data=., paired=FALSE)) %>% 
  summarise(variable, W=w$statistic, P.value = w$p.value)

res

# write results to file
write.csv(as.data.frame(res), "pi_data_wilcoxon.csv")

# if you insist to use anova....

#for each one
str(pi_data)

Am_aov=aov(Am~Group, data=pi_data)
summary(Am_aov)

# for the whole bunch

library(broom)

summaries = pi_data_long %>% group_by(variable) %>%
  do(tidy(aov(Value ~ Group, data = .)))
summaries

# write results to file
write.csv(as.data.frame(summaries), "pi_data_anova.csv")


#### photosyrvey

setwd("C:/Users/user/Desktop/Methods/ggplot") # set working directory

#load the metadata- NOTE: we work at the transect level.
photo_metadata=read.csv("Photosurvey_metadata.csv", header=TRUE, row.names=1, stringsAsFactors = TRUE)
str(photo_metadata)

# load the processed and filtered coverage data by taxonomic group
photosurvey_coverage=read.csv("Photosurvey_processed_data.csv", header=TRUE, row.names=1, stringsAsFactors = TRUE)
str(photosurvey_coverage)

#make sure the order of trnasect_IDs is the same in the data and the metadata
ord=match(row.names(photosurvey_coverage), row.names(photo_metadata))
photo_metadata=photo_metadata[ord,]

#merge metadata and coverage values

Photosurvey=cbind(photo_metadata, photosurvey_coverage)
str(Photosurvey)

# let's look at the total coverage in relation to site

library(ggplot)
ggplot(Photosurvey, aes(x=site, y=live_coverage))+
  geom_point()+
  theme_light()

ggplot(Photosurvey, aes(x=site, y=live_coverage))+
  geom_point(position=position_jitter(width=0.2))+
  theme_light()

ggplot(Photosurvey, aes(x=site, y=live_coverage))+
  geom_point(aes(color=as.factor(depth)),position=position_jitter(width=0.2))+
  theme_light()

ggplot(Photosurvey, aes(x=site, y=live_coverage))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(aes(color=as.factor(depth)),position=position_jitter(width=0.2))+
  theme_light()

# now test

#1. test homogeneity of variance

bartlett.test(Photosurvey$live_coverage~Photosurvey$site)

#2) test difference in coverage levels

kruskal.test(live_coverage~site, data=Photosurvey)

# now let's moove to season


ggplot(Photosurvey, aes(x=season, y=live_coverage))+
  geom_point()+
  theme_light()

ggplot(Photosurvey, aes(x=season, y=live_coverage))+
  geom_point(position=position_jitter(width=0.2))+
  theme_light()

ggplot(Photosurvey, aes(x=season, y=live_coverage))+
  geom_point(aes(color=as.factor(depth)),position=position_jitter(width=0.2))+
  theme_light()

ggplot(Photosurvey, aes(x=season, y=live_coverage, fill=site))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(position=position_jitterdodge(jitter.width = 0.2), size=1)+
  theme_light()+
  facet_grid(.~depth)

### now let's test for all factors together- non-parametric anova
library(ARTool)
m=art(live_coverage~site+as.factor(depth)+season+site*as.factor(depth)*season, data=Photosurvey)
anova(m)


### let's examine the sampler....

ggplot(Photosurvey, aes(x=sampler, y=live_coverage))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(aes(color=as.factor(depth)),position=position_jitter(width=0.2))+
  theme_light()


#1. test homogeneity of variance

bartlett.test(Photosurvey$live_coverage~Photosurvey$sampler)

#2) test difference in coverage levels

kruskal.test(live_coverage~sampler, data=Photosurvey)



#### what is the relatedness between coverage by different groups? we will do correlations

library(Hmisc)
str(Photosurvey)
# variables 10 to 22 have the measurements

corrs=rcorr(as.matrix(Photosurvey[,10:22]), type="spearman")

#we need a function that will take the square matrix and turn it to long format.

flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

#now we apply this function to our data
corrs_flat=flattenCorrMatrix(corrs$r, corrs$P)

#add p value adjustment using the Benjamini-Hochber method (BH)
corrs_flat$p.adj=p.adjust(corrs_flat$p, "BH")

write.csv(corrs_flat, "Taxonomic_groups_spearman.csv")

# now plot your correlation of interest e.g., my taxon of interest and live coverage
str(Photosurvey)

ggplot(Photosurvey, aes(x=Soft.Substrate, y=live_coverage))+
  geom_point()+
  geom_smooth(method='lm')+
  theme_light()

