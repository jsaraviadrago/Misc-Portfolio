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

# Create an empty raster
r <- raster(extent(df), ncol = 100, nrow = 100)

# Rasterize the polygon
r <- rasterize(df, r, field = 1, fun = 'first')

# Convert the raster to a matrix
height_matrix <- as.matrix(r)

# Replace NA values with 0
height_matrix[is.na(height_matrix)] <- 0

# Ensure the RGL device is opened
rgl::rgl.open()

# Plot with rayshader
height_matrix %>%
  sphere_shade(texture = "imhof1") %>%
  plot_3d(height_matrix, zscale = 10, windowsize = c(800, 800))

# Render a movie
render_movie("C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\triforce_movie.mp4", frames = 360, fps = 30, 
             phi = 45, zoom = 0.75, theta = seq(0, 360, length.out = 360))
