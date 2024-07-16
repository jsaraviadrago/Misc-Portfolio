library(sf)
library(rayshader)
library(rayrender)
library(ggplot2)
# Coordinate seperate in grids for simplicity
#x <- c(0,1,2,3,1,2,4)
#y <- c(0,3,0,3,3,6,0)

# Plotting with grids so I can have an idea of measurement
#plot(x,y)

# Creating the triforce
multipoint <-  st_multipoint(matrix(c(0,10,20,30,10,20,40,0,30,0,30,30,60,0),
                                    ncol = 2))

# Creating the polygon
polyg <-  st_cast(multipoint, "POLYGON")

# Converting to sf object
polyg_sf <- st_sfc(polyg)

# Creating a data frame from the sf object
df <- st_as_sf(data.frame(geometry = polyg_sf))

# Plotting with ggplot
triforce <- ggplot() +
  geom_sf(data = df, fill = "gold", color = "black")+ 
  theme(panel.background = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.line.x = element_blank(),
        axis.line.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(), legend.position="none")



plot_gg(triforce, width = 4, height = 4, scale = 400,
        multicore = F) 
render_movie(filename = "C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\mapa.mp4",
             theta = -45, phi = seq(90,360, by=2),
             zoom = 0.5,fov = 130)