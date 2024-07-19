## Script Gap Minder animado

library(ggplot2)
library(gganimate)
#library(gifski)
#library(png)

# Olympic medals

url_data_dictionary <- "https://raw.githubusercontent.com/jsaraviadrago/Misc-Portfolio/main/0.%20Fun%203D%20plots%20and%20art/dictionary.csv"
url_data_summer <- "https://raw.githubusercontent.com/jsaraviadrago/Misc-Portfolio/main/0.%20Fun%203D%20plots%20and%20art/summer.csv" 



data_dictionary <- read.csv(url_data_dictionary)
data_summer <- read.csv(url_data_summer)  

head(data_dictionary)
head(data_summer)

data_summary_medals <- data_summer |>
  dplyr::group_by(Year, Country, Medal) |> 
  dplyr::summarise(Medal = dplyr::n()) |> 
  dplyr::summarise(Total_medals = sum(Medal))

data_complete <- dplyr::left_join(data_summary_medals, data_dictionary,
                                  by = c("Country"="Code"))


#adding extra customization (labels, title) and changing size of bubbles
gap_plot <- ggplot(data_complete, aes(x = GDP.per.Capita,
                                            y = Total, color = Country, size = Population)) +
  geom_point(alpha=0.8) + scale_x_log10() + scale_size(range = c(.1, 20), name="Population")+
  theme(panel.background = element_blank(), 
        legend.position = "none")+
  labs(x = 'GDP per Capita [in USD]', y = 'Total medallas',
                title = "Medallas en las olimpiadas y GDP") +
# gganimate code
ggtitle("Year: {frame_time}") +
  transition_time(Year) +
  ease_aes("linear") +
  enter_fade() +
  exit_fade()

# animate
animate(p, width = 450, height = 450)
# save as a GIF
anim_save("output.gif")


