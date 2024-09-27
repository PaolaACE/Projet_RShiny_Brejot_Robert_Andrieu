#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(data.table)
library(shiny)
library(tidygeocoder)
library(leaflet)

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
              header = TRUE, sep = ";", stringsAsFactors = TRUE)
data$taux_de_reponse <- as.numeric(data$taux_de_reponse)

summary(data)

df <- data %>% group_by(academie) %>%
  summarise(taux_reponse_totale = mean(taux_de_reponse))

df <- df[2:30,]
df$academie <- as.character(df$academie)

df <- df %>%
  geocode(academie, method = 'osm', full_results = TRUE)

df <- df[,1:4]


# Define server logic required to draw a histogram
function(input, output, session) {
  output$dataTable <- renderDataTable(data)
  
  output$mymap <- renderLeaflet({
    leaflet(df) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~long,
        lat = ~lat,
        radius = 6,
        color = "blue",
        fillOpacity = 0.8,
        popup = ~paste("<strong>Académie :</strong>", academie, "<br>",
                       "<strong>Taux de réponse moyen :</strong>", round(taux_reponse_totale), "%")
      )
  })
}
