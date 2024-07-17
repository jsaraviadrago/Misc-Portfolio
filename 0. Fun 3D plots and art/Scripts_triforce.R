library(sf)
library(rayshader)
library(rayrender)
library(ggplot2)
library(rgl)
library(raster)

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

## Creating simple plot
# Rendering into a moving plot with rayshader                                        


plot_gg(triforce, height=3, width=3.5, multicore=TRUE, pointcontract = 0.7, soliddepth=-200)
