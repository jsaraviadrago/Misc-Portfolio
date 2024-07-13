library(ggplot2)
library(sp)
library(sf)
library(dplyr)
library(rayshader)
library(av)
library(rgl)
library(geodata)
library(viridis)


# Levantar el mapa
peru_dpto <- geodata::gadm("Peru", level = 1, path = ".") #Nivel departamento

#Mapas generales: Convertir con sf para que sea un data frame y se puede graficar. 
fperu_dpto <- st_as_sf(peru_dpto)


# Cargar dataframe con equipos
url <- "https://raw.githubusercontent.com/jsaraviadrago/Misc-Portfolio/main/0.%20Fun%203D%20plots%20and%20art/data_equipos_vf1.csv"

data_equipos <- read.csv(url)

data_equipos_departamento <- data_equipos |> 
  group_by(region) |> 
  summarise(Cantidad_equipos = n())

# Limpiar nombres para que estén igual 
data_equipos_departamento <- data_equipos_departamento |> 
  mutate(region = case_when(
    region == "Áncash" ~ "Ancash",
    region == "Lima Región" ~ "Lima Province",
    region == "Lima Metropolitana" ~ "Lima",
    TRUE ~ region))


#Juntar la información de la cantidad de equipos con el data frame

fperu_dpto <- left_join(fperu_dpto, data_equipos_departamento,
                        by = c("NAME_1" = "region"))


data.frame(fperu_dpto)

# mapa Peru blanco y negro

ggplot(fperu_dpto) +
  geom_sf(aes(fill = Cantidad_equipos)) + 
  scale_fill_viridis_c(option = "magma", direction = 1) +
  theme(panel.background = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())




# mapa del peru con colores plano
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

# Rendering into a moving plot with rayshader                                        
plot_gg(MapaPeru, width = 4, height = 4, scale = 400,
        multicore = F) 
render_movie(filename = "C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\mapa.mp4",
             theta = -45, phi = seq(90,360, by=2),
             zoom = 0.5,fov = 130)

