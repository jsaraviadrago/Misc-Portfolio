## Script Gap Minder animado
library(dplyr)
library(ggplot2)
library(gganimate)
library(lubridate)
#library(gifski)
#library(png)

# Olympic medals

url_data_rankings <- "https://raw.githubusercontent.com/jsaraviadrago/Misc-Portfolio/main/fifa_rankings.csv"
url_data_matches <- "https://raw.githubusercontent.com/jsaraviadrago/Misc-Portfolio/main/results.csv" 



data_rankings <- read.csv(url_data_rankings)
data_matches <- read.csv(url_data_matches)  

data_rankings <- data_rankings %>% 
  mutate(
    date = as.Date(rank_date),
    year = year(rank_date)) 

data_summary_rankings <- data_rankings |>
  dplyr::group_by(year, team) |> 
  dplyr::summarise(Points = max(total_points),
                   confederation = first(confederation),
                   country_abrv = first(country_abrv)) 

data_matches <- data_matches |> 
  mutate(
    date = as.Date(date),
    year = year(date)) 

data_matches <- data_matches |> 
  filter(year >= 1992)

data_matches_summary_local <- data_matches |> 
  group_by(year, home_team) |>
  summarise(Goles_local_favor = sum(home_score),
            Goles_local_contra = sum(away_score),
            Total_local_partidos = n())

data_matches_summary_local <- data_matches_summary_local |> 
  mutate(Dif_goles_local = Goles_local_favor - Goles_local_contra) |> 
  select(-Goles_local_favor, -Goles_local_contra)


data_matches_summary_visita <- data_matches |> 
  group_by(year, away_team) |>
  summarise(Goles_visita_favor = sum(away_score),
            Goles_visita_contra = sum(home_score),
            Total_visita_partidos = n())

data_matches_summary_visita <- data_matches_summary_visita |> 
  mutate(Dif_goles_visita = Goles_visita_favor - Goles_visita_contra) |> 
  select(-Goles_visita_favor, -Goles_visita_contra)



data_matches_summary <- full_join(data_matches_summary_local, 
                                   data_matches_summary_visita,
                                   by =c("year" = "year", "home_team" = "away_team"))

data_matches_summary <- data_matches_summary |> 
  mutate(Total_partidos = Total_local_partidos + Total_visita_partidos,
         Dif_goles = Dif_goles_local + Dif_goles_visita)










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


