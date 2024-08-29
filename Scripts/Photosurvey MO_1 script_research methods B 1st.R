#### survey_methodology_course

# the # sign is your best friend! use it to insert comments that will assist in remembering... everything.

#### stage 1: packages ####

#install required packages
#once a package is installed, there is no need to re-install it, except for new versions and when you update your R version
install.packages("dplyr")
install.packages('janitor')
install.packages('tidyr')
install.packages('tibbel')
install.packages('ggplot2')
install.packages('reshape2')
install.packages('tidyverse')
install.packages('viridis')

# load required pakcages
library(dplyr)
library(tidyr)
library(ggplot2)
library(janitor)
library(tibble)
library(reshape2)
library(tidyverse)
library(viridis)

# check and record pakcage versions
packageVersion("dplyr")
packageVersion("tidyr")
packageVersion("ggplot2")
packageVersion("janitor")
packageVersion("tibble")
packageVersion("reshape2")
packageVersion("tidyverse")
packageVersion("viridis")

# check version of R
R.version.string


#### stage 2: uploading the data ####

# set the working directory (the path to the folder) in which the data is and to which you want to write things
# if you are using windows operation system, be sure to change the \ to / between sub folders

setwd("D:/U. Haifa/Second semester/Research Methods/Research methods B/R toturial")


# load the data
#name of object=read.csv("name of file", header=TREU/FALSE, row.names= the number of column in which the row names are, stringsAsFactors=TRUE/FALSE)

data=read.csv("photosurvey_MO_1.csv", header=TRUE, stringsAsFactors = TRUE)

# check the class of the object you have created
class(data)

# check the dimensions of the object
dim(data)

# check the structure of the object, i.e., what does R sea?
str(data)

# check if there are any missing values in your data
which(is.na(data))

# set the "sample_date" variable as a Date type of data.
# note: the $ sign enables to select/target a specific variable in your data frame

data$sample_date=excel_numeric_to_date(as.numeric(as.character(data$sample_date)), date_system = "modern")

# change the "transect" and "depth" variables from integer to factor
data$transect=as.factor(data$transect)
data$depth=as.factor(data$depth)

#we also add a conditional variable, who sampled the data. before 2020 it is Stephan and after it is Hagai

data$sampler=ifelse(data$Year<2020, "Stefan","Hagai")

# let's also make a new variable combining Year and season
data$Year_season=as.factor(paste(data$Year, data$season, sep="_"))

# check the structure of the object, i.e., what does R sea?
str(data)

#### explore the data ####

str(data)

# basic commands
summary(data)
summary(data$sample_date)
summary(data$Year)

unique(data$Year)
sort(unique(data$Year))
length(unique(data$Year))

unique(data$sample_date)
sort(unique(data$sample_date))
length(unique(data$sample_date))

# for convinience, let us add a variable to the table with the value 1, representing an observation

data$obs=1
str(data)

# additionally, let us give each transect a unique name

data$transect_id=as.factor(paste(data$sample_date, data$site, data$depth, data$transect, sep="_"))
str(data)

#and add a factor combining Year and season

str(data)


# now let us try to make a table describing the information we have

Photo=aggregate(image_name~Year+season+site+depth+transect_id, data=data, FUN=function(x) length(unique(x)))
Photo

transects=aggregate(transect_id~Year+season+Year_season+site+depth, data=data, FUN=function(x) length(unique(x)))

str(transects)

transects_wide=as.data.frame(transects %>% pivot_wider(names_from=c(Year,season), values_from=transect_id))
str(transects_wide)

write.csv(transects_wide, "summary_transects_year_site_season.csv")



# and make that into a figure

ggplot(transects, aes(x=Year_season, y=transect_id, fill=as.factor(depth)))+
  geom_bar(stat="identity", position=position_dodge())+
  facet_grid(site~.)

# now let us look at the actual content

levels(data$taxonomy_group)

# what is "other"?
# we will subset the group "other"
str(data)
Other=data[data$taxonomy_group=="Other",]
str(Other)
dim(Other)
nrow(Other)/nrow(data)*100

levels(Other$name)
levels(droplevels(Other$name))

dim(Other)
nrow(Other)/nrow(data)*100

# how many are there of each level? do we have a problem?

nrow(Other[Other$name=="Sand / Rubble",])
nrow(Other[Other$name=="Shadow",])
nrow(Other[Other$name=="tag/frame/zspar etc",])



length(unique(data$image_name))
length(unique(Other$image_name))



#maybe there are problematic images?
str(Other)

# sum the number of "other" in each image
Other_perImage=aggregate(obs~image_name+sample_date+site+Year+season+Year_season+depth+name+transect_id, data=Other, FUN="sum")
str(Other_perImage)

min(Other_perImage$obs)
max(Other_perImage$obs)
median(Other_perImage$obs)
quantile(Other_perImage$obs,prob=0.9)
quantile(Other_perImage$obs,prob=0.95)

ggplot(Other_perImage, aes(x=as.factor(Year), y=obs))+
  geom_boxplot(outlier.shape = NA)+
  geom_point(position=position_jitter(width=0.2),size=0.8, aes(color=depth))

# each image has 16 point. we cannot afford more than 4 missing data...
# How many are there?
nrow(Other_perImage[Other_perImage$obs>4,])
length(unique(data$image_name))

# let's make a vector containing the "image_name" that are problematic
bad_images=as.vector(levels(droplevels(Other_perImage[Other_perImage$obs>4,]$image_name)))
length(bad_images)

#maybe we have "bad" transects, with a lot of "bad" images?
# let's now keep only bad images
Other_bad_images=Other_perImage[Other_perImage$obs>4,]
Other_bad_images$bad_image=1
str(Other_bad_images)

Bad_image_per_transect=aggregate(bad_image~site+Year+season+Year_season+depth+name+transect_id+sample_date, data=Other_bad_images, FUN="sum")
str(Bad_image_per_transect)

min(Bad_image_per_transect$bad_image)
max(Bad_image_per_transect$bad_image)
median(Bad_image_per_transect$bad_image)
quantile(Bad_image_per_transect$bad_image,prob=0.9)
quantile(Bad_image_per_transect$bad_image,prob=0.95)

# let us consider we are in the clear with respect to possible "bad transects"
# now let us clear the "bad images" from our data
str(data)
length(unique(data$image_name))

data_filtered=data[!data$image_name %in% bad_images,]
str(data_filtered)
length(unique(data_filtered$image_name))

# 96 images removed. well done!


#### live coverage ####

# can we finnaly look at the results? not yet.
# we need to determine for each observation if it is alive or dead.

levels(data_filtered$taxonomy_group)
#create a vector with the factor levels we consider as alive
live=c("Algae","Annelida" ,"Bryozoa" ,"Chordata", "Cnidaria", "Cyanobacteria","Echinodermata","Mollusca","Porifera" )
live

#create a new variable in data_filtered denoting 1 for live and 0 for non-live
data_filtered$live= ifelse(data_filtered$taxonomy_group %in% live,1,0)
str(data_filtered)

# now let's calculate % live coverage per transect
# we first need to determine the % live coverage per image.
data_filtered_by_image=aggregate(live~site+Year+depth+season+Year_season+transect_id+image_name+sample_date+sampler, data=data_filtered, FUN="sum")
str(data_filtered_by_image)

# now we calculate % live coverage per image
data_filtered_by_image$live_coverage=data_filtered_by_image$live/16*100
str(data_filtered_by_image)

# now, as the sample unit is the transect, we will average the coverage of the images within transect.
# note, the number of photos per transect is not equal. we are not going to deal with that today.
data_filtered_by_transect=aggregate(live_coverage~site+Year+depth+season+Year_season+transect_id+sample_date+sampler,data=data_filtered_by_image, FUN="mean")
str(data_filtered_by_transect)

# let's plot the results

ggplot(data_filtered_by_transect, aes(x=as.factor(Year), y=live_coverage, fill=season))+
  geom_boxplot()+
  facet_grid(site~.)

ggplot(data_filtered_by_transect, aes(x=as.factor(Year), y=live_coverage, fill=season))+
  geom_boxplot()+
  facet_grid(depth~.)

# confusing, ain't it?


#### composition ####

# let's look at the composition finally????

str(data_filtered)

# now we will count the number of observations per taxonomic group per image 
#and calculate % coverage for each in each image
#then, we average across transect

data_filtered_by_taxa_by_transect=aggregate(obs~taxonomy_group+Year+site+depth+site_depth+season+Year_season+transect_id+sample_date+sampler, data=data_filtered, FUN="sum")
str(data_filtered_by_taxa_by_transect)

#calculate the total number of points per transect
p_transect=aggregate(obs~transect_id, data=data_filtered, FUN="sum")

#add variable based on mached index from another object
data_filtered_by_taxa_by_transect$total_P_transect=p_transect$obs[match(data_filtered_by_taxa_by_transect$transect_id, p_transect$transect_id)]
str(data_filtered_by_taxa_by_transect)

data_filtered_by_taxa_by_transect$taxa_coverage= data_filtered_by_taxa_by_transect$obs/data_filtered_by_taxa_by_transect$total_P_transect*100
str(data_filtered_by_taxa_by_transect)


# we need to fix a bug.... not all taxa are represented in all sample, even not as a zero....

#split metadata of transect_ID
str(data_filtered_by_taxa_by_transect)
metadata_transect_ID=data_filtered_by_taxa_by_transect[,c("transect_id","sample_date","taxonomy_group","Year", "site", "depth", "site_depth",
                                                          "season", "Year_season", "sampler")]
str(metadata_transect_ID)

#now we select the taxon information for with the transect_id
to_wide=data_filtered_by_taxa_by_transect[,c("transect_id","taxonomy_group", "taxa_coverage")]
wide=to_wide %>% pivot_wider(names_from=c("transect_id"), values_from = c("taxa_coverage"), values_fill = 0)

str(wide)
wide_to_long=wide %>% pivot_longer(cols=c(2:507), names_to= "transect_id", values_to= "taxa_coverage")
str(wide_to_long)
# add back the transect metadata information

data_taxonomy_transect= merge(metadata_transect_ID, wide_to_long, all=TRUE)
str(data_taxonomy_transect)

#correct the metadata missing values values
data_taxonomy_transect$sample_date=metadata_transect_ID$sample_date[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$Year=metadata_transect_ID$Year[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$season=metadata_transect_ID$season[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$depth=metadata_transect_ID$depth[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$site=metadata_transect_ID$site[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$Year_season=metadata_transect_ID$Year_season[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$site_depth=metadata_transect_ID$site_depth[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]
data_taxonomy_transect$sampler=metadata_transect_ID$sampler[match(data_taxonomy_transect$transect_id, metadata_transect_ID$transect_id )]


# now we can average among transects within specific sampling date
str(data_taxonomy_transect)

data_taxonomy_transect_ave=aggregate(taxa_coverage~taxonomy_group+sample_date+Year+site+depth+site_depth+season+Year_season+sampler,
                                     data=data_taxonomy_transect, FUN="mean")

# overview

ggplot(data_taxonomy_transect, aes(x=site_depth, y=taxonomy_group, fill=taxa_coverage))+
  geom_tile()+
  scale_fill_viridis(option="D", direction=1)+
  xlab("Site and depth")+
  ylab("Taxon")



ggplot(data_taxonomy_transect, aes(x=Year, y=taxonomy_group, fill=taxa_coverage))+
  geom_tile()+
  scale_fill_viridis(option="D", direction=1)+
  facet_grid(.~season)+
  xlab("Year")+
  ylab("Taxon")


# what happened at 2020? the person sampling the data was replaced
# we will add a variable stating before and after 2020.


ggplot(data_taxonomy_transect, aes(x=sampler, y=taxonomy_group, fill=taxa_coverage))+
  geom_tile()+
  scale_fill_viridis(option="D", direction=1)+
  facet_grid(.~depth)+
  xlab("Sampler")+
  ylab("Taxon")

### now let us follow a specific group throughout the years.

Algae_by_transect=data_filtered_by_taxa_by_transect[data_filtered_by_taxa_by_transect$taxonomy_group=="Algae",]

# plot Algae by year and season

ggplot(Algae_by_transect, aes(x=Year_season, y=taxa_coverage))+
  geom_point(aes(color=depth), size=2, position=position_jitter(width=0.2))+
  facet_grid(site~., scales="free")+
  xlab("Year and season")+
  ylab("Coverage (%)")

# now we will look at the trend just for depth 45

Algae_by_transect_45=Algae_by_transect[Algae_by_transect$depth=="45",]

#and we will use a line graph

ggplot(Algae_by_transect_45, aes(x=sample_date, y=taxa_coverage, color=site))+
  geom_point()+
  geom_smooth(se=FALSE)+
  xlab("Date")+
  ylab("Coverage (%)")


#### asignment sample ####
ggplot(transects, aes(x=Year_season, y=transect_id, fill=as.factor(depth)))+
  geom_bar(stat="identity", position=position_dodge())+
  facet_grid(site~.)


str(data_taxonomy_transect)

# 1) subsample according to assigned sites and duration. example: select Achziv and SdotYam, select years 2016-2019

mySites=c("Achziv","SdotYam")
myYears=c("2016", "2017", "2018", "2019")

mySubset=data_taxonomy_transect[data_taxonomy_transect$site %in% mySites,  ]
mySubset=mySubset[mySubset$Year %in% myYears,  ]
str(mySubset)

# 2) table the data and save
# first average by year, season and depth
mySubset_ave=aggregate(taxa_coverage~Year+site+season+depth+taxonomy_group, data=mySubset, FUN="mean")
str(mySubset_ave)


mySubset_table=as.data.frame(mySubset_ave %>% pivot_wider(names_from=c(Year,season, depth,site), values_from=taxa_coverage))
str(mySubset_table)
colSums(mySubset_table[,-1])
# write the table to file
write.csv("mySubset_table", "mySubset_table.csv")


# 3) plot the composition

ggplot(mySubset_ave[mySubset_ave$season=="Fall",], aes(x=as.factor(Year), y=taxa_coverage, fill=taxonomy_group))+
  geom_bar(stat="identity")+
  facet_grid(site~depth)

ggplot(mySubset_ave[mySubset_ave$season=="Spring",], aes(x=as.factor(Year), y=taxa_coverage, fill=taxonomy_group))+
  geom_bar(stat="identity")+
  facet_grid(site~depth)

# by season and site only
mySubset_ave_season=aggregate(taxa_coverage~site+season+taxonomy_group, data=mySubset, FUN="mean")
str(mySubset_ave_season)


ggplot(mySubset_ave_season, aes(x=season, y=taxa_coverage, fill=taxonomy_group))+
  geom_bar(stat="identity")+
  facet_grid(.~site)

# by season and depth only
mySubset_ave_season_depth=aggregate(taxa_coverage~depth+season+taxonomy_group, data=mySubset, FUN="mean")
str(mySubset_ave_season_depth)


ggplot(mySubset_ave_season_depth, aes(x=season, y=taxa_coverage, fill=taxonomy_group))+
  geom_bar(stat="identity")+
  facet_grid(.~depth)

# by year and depth only
mySubset_ave_year_depth=aggregate(taxa_coverage~depth+Year+taxonomy_group, data=mySubset, FUN="mean")
str(mySubset_ave_year_depth)


ggplot(mySubset_ave_year_depth, aes(x=as.factor(Year), y=taxa_coverage, fill=taxonomy_group))+
  geom_bar(stat="identity")+
  facet_grid(.~depth)


# 4) select the dominant/ most interesting group (look at the table you created)


Bryozoa=mySubset[mySubset$taxonomy_group=="Bryozoa",]
str(Bryozoa)
summary(Bryozoa)


# plot dominant/ most interesting group by year and season

ggplot(Bryozoa, aes(x=as.factor(Year), y=taxa_coverage, fill=season))+
  geom_boxplot()+
  facet_grid(depth~site)

ggplot(Bryozoa, aes(x=sample_date, y=taxa_coverage, color=site))+
  geom_point()+
  geom_smooth(se=FALSE)+
  xlab("Date")+
  ylab("Coverage (%)")+
  facet_grid(depth~.)
