library(sf)
library(rayshader)
library(rayrender)
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

# Plotting the squares
plot(polyg, col = "Gold")



plot_gg(triforce, width = 4, height = 4, scale = 400,
        multicore = F) 
render_movie(filename = "C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\mapa.mp4",
             theta = -45, phi = seq(90,360, by=2),
             zoom = 0.5,fov = 130)