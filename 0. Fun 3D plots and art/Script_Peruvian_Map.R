library(ggplot2)
library(sp)
library(raster)
library(sf)
library(rgeos)
library(dplyr)
library(rayshader)
library(av)
library(rgl)

peru_dpto<-getData('GADM',country='PER',level=1) #Nivel departamento

#Mapas generales: Convertir con fortify
fperu_dpto<-fortify(peru_dpto)

dpto_geometry <- fperu_dpto %>%
  st_as_sf(coords = c("long", "lat"), crs = 4326) %>%
  group_by(id) %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_cast("POLYGON") 


### Mapa del Peru
rgl.open()

MapaPeru <- ggplot(data = dpto_geometry)+
  geom_sf(fill= "#FF0000", color = "#FFFFFF") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.background = element_rect(fill = '#33B50C',
                                        color = '#33B50C'),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title = element_blank(), legend.position="none")
                                        
plot_gg(MapaPeru, width = 4, height = 4, scale = 400,
        multicore = F) 
render_movie(filename = "mapa.mp4",
             theta = -45, phi = seq(90,360, by=2),
             zoom = 0.5,fov = 130)

