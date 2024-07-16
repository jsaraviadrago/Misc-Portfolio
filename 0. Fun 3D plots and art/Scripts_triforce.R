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
#plot_gg(triforce, width = 4, height = 4, scale = 400,
#        multicore = F) 

# Create an empty raster
r <- raster(extent(df), ncol = 100, nrow = 100)

# Rasterize the polygon
r <- rasterize(df, r, field = 1, fun = 'first')

# Convert the raster to a matrix
height_matrix <- as.matrix(r)

# Replace NA values with 0
height_matrix[is.na(height_matrix)] <- 0

# Create a hillshade map
hillshade <- height_matrix %>%
  sphere_shade(texture = "imhof1")


# Plot with rayshader and capture snapshot
plot_3d(heightmap = height_matrix, hillshade = hillshade, zscale = 10,
        windowsize = c(800, 800), solid = TRUE, shadow = TRUE)

# Define render parameters
frames <- 360
fps <- 30
phi <- 45
zoom <- 0.75
theta_sequence <- seq(0, 360, length.out = frames)

# Create a directory to save frames
dir.create("frames")

# Render each frame and save as PNG
for (i in seq_along(theta_sequence)) {
  theta <- theta_sequence[i]
  render_camera(theta = theta, phi = phi, zoom = zoom)
  render_snapshot(filename = sprintf("frames/frame_%03d.png", i))
}

# Combine frames into a movie using ffmpeg
system("ffmpeg -framerate 30 -i frames/frame_%03d.png -c:v libx264 -pix_fmt yuv420p triforce_movie.mp4")


# # Plot with rayshader
# height_matrix %>%
#   sphere_shade(texture = "imhof1") %>%
#   plot_3d(height_matrix, zscale = 10, windowsize = c(800, 800))
# 
# # Render a movie
# render_movie("C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\triforce_movie.mp4", frames = 360, fps = 30, 
#              phi = 45, zoom = 0.75, theta = seq(0, 360, length.out = 360))
