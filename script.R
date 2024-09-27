
library(data.table)
library(dplyr)
library(tidygeocoder)
library(sf)

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
              header = TRUE, sep = ";", stringsAsFactors = TRUE, na.strings = "")
data$taux_de_reponse <- as.numeric(data$taux_de_reponse)
data$taux_dinsertion <- as.numeric(data$taux_dinsertion)

summary(data)

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

data %>% group_by(annee) %>% summarise(salaire_brut_annuel_estime = mean(salaire_brut_annuel_estime))
plot(data$annee, data$salaire_brut_annuel_estime)


