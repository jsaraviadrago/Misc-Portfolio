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
    year = year(Date),
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

data_agregada <- group_by(data_running, year, hour) %>% 
  summarise(Personas = n())

Heat_map <- ggplot(data_agregada, aes(year,hour, fill= Personas)) + 
  geom_tile() +
  theme(panel.background = element_blank(),
        axis.text.x = element_text(angle = 0),
        legend.title = element_blank())+
  scale_fill_viridis(discrete=FALSE) +
  scale_x_continuous(breaks = seq(2020,2024, by = 1))+
  scale_y_continuous(breaks = seq(4,22, by = 1)) +
  labs(x = "", y="")+
  ggtitle("Carreras por hora y año")




plot_gg(Heat_map,multicore=TRUE,width=5,height=3,scale=310)    # Plot_gg de rayshader
render_movie("C:\\Users\\JuanCarlosSaraviaDra\\Downloads\\Heat_map.mp4",
             frames = 720, fps=30,zoom=0.6,fov = 30)
  
  

