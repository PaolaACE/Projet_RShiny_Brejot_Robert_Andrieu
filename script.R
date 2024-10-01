
library(data.table)
library(dplyr)
library(tidygeocoder)
library(sf)

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
              header = TRUE, sep = ";", stringsAsFactors = TRUE)
data$taux_de_reponse <- as.numeric(data$taux_de_reponse)
data$taux_dinsertion <- as.numeric(data$taux_dinsertion)
data$taux_dinsertion[data$taux_dinsertion == "nd" | data$taux_dinsertion == "ns"] <- NA
data$salaire_brut_annuel_estime[data$salaire_brut_annuel_estime == "nd" | data$salaire_brut_annuel_estime == "ns" | 
                                  data$salaire_brut_annuel_estime == "" | data$salaire_brut_annuel_estime == "."] <- NA
data$salaire_brut_annuel_estime <- as.numeric(data$salaire_brut_annuel_estime)

summary(data$salaire_brut_annuel_estime)

df <- data %>% group_by(academie) %>%
  summarise(taux_reponse_totale = mean(taux_de_reponse), taux_insertion_moyen = mean(taux_dinsertion))

df <- df[2:30,]
df$academie <- as.character(df$academie)

df <- df %>%
  geocode(academie, method = 'osm', full_results = TRUE)

df <- df[,1:5]

library(leaflet)

leaflet(df) %>%
  addTiles() %>%
  setView(lng = 2.2137, lat = 46.2276, zoom = 6) %>% 
  addCircleMarkers(
    lng = ~long,
    lat = ~lat,
    radius = 6,
    color = "blue",
    fillOpacity = 0.8,
    popup = ~paste("<strong>Académie :</strong>", academie, "<br>",
                   "<strong>Taux de réponse moyen :</strong>", round(taux_reponse_totale), "%", "<br>",
                   "<strong>Taux d'insertion moyen :</strong>", round(taux_insertion_moyen), "%")
  )

library(ggplot2)

data2 <- data[!is.na(salaire_brut_annuel_estime)]
data2 <- data2 %>% group_by(annee, academie) %>% summarise(salaire_brut_annuel_estime = mean(salaire_brut_annuel_estime))

filtere_data <- data2 %>% filter(academie %in% list("Rennes", "Lyon"))

ggplot(filtere_data, aes(x=annee, y=salaire_brut_annuel_estime, color=academie)) +
  geom_line(size=1) +
  geom_point(size = 2) +
  labs(y = "Salaire (€)",
       x = "Année",
       color = "Académie") +
  theme_minimal() +
  theme(legend.position = "bottom")




