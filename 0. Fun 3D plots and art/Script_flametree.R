library(devtools)
library(flametree)
library(viridis)
library(ggplot2)

dat <- flametree_grow(seed = 1, time = 5, 
                      scale = c(2,4),
                      split = 5) # data structure

shades <- c("#A06AB4", "#FFD743", "#07BB9C", "blue")

img <- flametree_plot(data = dat,
                      background = "grey",
                      palette = shades)          # ggplot object

n_colors <- 10
colors <- viridis(n_colors)

dat2 <- flametree_grow(seed = 1, time = 6, 
                       scale = c(2,4,6,8),
                       split = 2) # data structure
img2 <- flametree_plot(data = dat,
                       palette = colors)  

flametree_save(img, 'C:\\Users\\JuanCarlosSaraviaDra\\Dropbox\\img.png')
