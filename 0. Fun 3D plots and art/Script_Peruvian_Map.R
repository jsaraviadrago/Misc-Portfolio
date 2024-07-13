library(ggplot2)
library(sp)
library(sf)
library(dplyr)
library(rayshader)
library(av)
library(rgl)
library(geodata)


# Levantar el mapa
peru_dpto <- geodata::gadm("Peru", level = 1, path = ".") #Nivel departamento

#Mapas generales: Convertir con sf para que sea un data frame y se puede graficar. 
fperu_dpto <- st_as_sf(peru_dpto)

# mapa Peru blanco y negro
ggplot(fperu_dpto) +
  geom_sf(fill = NA, colour = "black")

# mapa del peru con colores
MapaPeru <- ggplot(data = fperu_dpto)+
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

