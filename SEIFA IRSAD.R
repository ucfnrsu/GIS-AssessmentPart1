getwd()
setwd("C:/Users/richa/Documents/MSc Smart Cities/GIS/Coursework 1")
library(maptools)
library(RColorBrewer)
library(classInt)
library(OpenStreetMap)
library(sp)
library(rgeos)
library(tmap)
library(tmaptools)
library(sf)
library(rgdal)
library(geojsonio)
library(tidyverse)
library(ggmap)
library(ggplot2)

NSWSF <- read_shape("SA2_2016_AUST/SA2_2016_AUST_NSW.shp", as.sf = TRUE)
NSWSP <- readOGR("SA2_2016_AUST/SA2_2016_AUST_NSW.shp")

SEIFA2016_IRSAD <- read_csv("SA2 indexes_SEIFA2016 - IRSAD.csv", na="n/a")
SEIFA2016_IRSAD <- SEIFA2016_IRSAD[1:558,]
SEIFA2016_IRSAD <- data.frame(SEIFA2016_IRSAD)

SydSF <- read_shape("SA2_2016_AUST/SA2_2016_AUST_Syd.shp", as.sf = TRUE)
SydSP <- as(SydSF, "Spatial")
names(SEIFA2016_IRSAD)

SydDataMap <- append_data(SydSF,SEIFA2016_IRSAD, key.shp = "SA2_MAIN16", key.data = "X2016.Statistical.Area.Level.2...SA2..9.Digit.Code", ignore.duplicates = TRUE)
names(SydDataMap)

NSWDataMap <- append_data(NSWSF,SEIFA2016_IRSAD, key.shp = "SA2_MAIN16", key.data = "X2016.Statistical.Area.Level.2...SA2..9.Digit.Code", ignore.duplicates = TRUE)
names(NSWDataMap)

palette_explorer()

Sydbox <- as.vector(st_bbox(SydDataMap))
map <- get_stamenmap(Sydbox, zoom=10, maptype = "toner-lite")


#using tmap
tmap_mode("plot")
tm_shape(NSWDataMap, bbox = Sydbox) +
  tm_fill("#f2f2f2") +
  tm_borders("white", lwd = 0.1) +
  tm_layout(bg.color = "#dcf0fa") +
tm_shape(SydDataMap) +
  tm_fill(col="Decile",style="cat", n=11,palette="PiYG", textNA="", colorNA = "#f2f2f2", showNA = FALSE) +
  tm_borders("white", lwd = 0.1) +
  tm_compass(north = 0, type="arrow", show.labels = 1, cardinal.directions = "N") +
  tm_scale_bar(size=0.67) +
  tm_legend(title = "SEIFA - Index of Adv. & Disadv. (2016)", title.size = 0.5, position = c("left", "top"), text.size = 0.8) 
  
tmap_save(filename="Sydney IRSAD-R.png", height=8.3)  



#trying ggmap and failing - Palette1 won't work?
labels<-labs(list(title="SEIFA - Index of Adv. & Disadv. (2016)",x="Longitude", y="Latitude"))
palette1<-brewer.pal("PiYG",n=10)
palette2 <- scale_fill_manual(values=c("c51b7d", "#de77ae", "#f1b6da", "#fde0ef","#e6f5d0","#b8e186", "#7fbc41", "#4d9221","white"))                             #f7f7f7
                                      
ggmap(map) +
  geom_sf(mapping = aes(palette=palette1,fill=Decile),data = SydDataMap, inherit.aes = FALSE,alpha=0.7)+theme_void()+labels

?geom_sf
