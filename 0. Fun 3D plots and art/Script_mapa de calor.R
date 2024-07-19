library(readxl)
library(dplyr)
library(ggplot2)
library(hrbrthemes)
library(viridis)
library(rayshader)
library(lubridate)

url <- "https://raw.githubusercontent.com/jsaraviadrago/Misc-Portfolio/main/0.%20Fun%203D%20plots%20and%20art/Activities.csv"

data <- read.csv(url)

data <- data %>% 
  mutate(
    date = as.Date(Date),
    hour = hour(Date),
    minute = minute(Date),
    second = second(Date)
  ) %>% 
  mutate(
    format_date = format(date, "%m/%d/%Y"),
    format_hour = paste(hour, minute, second, sep = ":")
  )


data_running <- data |> 
  filter(Activity.Type == "Running")

data_agregada <- group_by(data_running, Number.of.Laps, Avg.HR) %>% 
  summarise(Personas = n())

table(data_agregada$Personas)



Heat_map <- ggplot(data_agregada, aes(dia,hora, fill= Personas)) + 
  geom_tile() +
  theme(panel.background = element_blank(),
        axis.text.x = element_text(angle = 90))+
  scale_fill_viridis(discrete=FALSE) +
  scale_x_continuous(breaks = seq(0,31, by = 1))+
  scale_y_continuous(breaks = seq(0,23, by = 1))
  plot_gg(Heat_map, scale = 250) 
render_movie(filename = "Heat_map.mp4",
             theta = -45, phi = 30,zoom = 0.5,fov = 130)
  
  

