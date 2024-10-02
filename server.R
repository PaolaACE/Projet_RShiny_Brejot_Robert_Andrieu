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
library(dplyr)
library(leaflet)
library(ggplot2)

### Import données ###

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
              header = TRUE, sep = ";", stringsAsFactors = TRUE)
data$taux_de_reponse <- as.numeric(data$taux_de_reponse)
data$taux_dinsertion <- as.numeric(data$taux_dinsertion)
data$taux_d_emploi <- as.numeric(data$taux_d_emploi)
data$salaire_brut_annuel_estime <- as.numeric(data$salaire_brut_annuel_estime)

data$taux_dinsertion[data$taux_dinsertion == "nd" | data$taux_dinsertion == "ns"] <- NA
data$taux_d_emploi[data$taux_d_emploi == "nd" | data$taux_d_emploi == "ns"] <- NA
data$salaire_brut_annuel_estime[data$salaire_brut_annuel_estime == "nd" | data$salaire_brut_annuel_estime == "ns" | 
                                  data$salaire_brut_annuel_estime == "" | data$salaire_brut_annuel_estime == "."] <- NA


### Preparation données carte ###

df <- data %>% group_by(academie) %>%
  summarise(taux_reponse_totale = mean(taux_de_reponse), taux_insertion_moyen = mean(taux_dinsertion))

df <- df[2:30,]
df$academie <- as.character(df$academie)

# df <- df %>%
#   geocode(academie, method = 'osm', full_results = TRUE)

#df <- df[,1:5]

### Preparation données graphes temporelles ###

# data2 <- data[!is.na(salaire_brut_annuel_estime)]
# data2 <- data2 %>% group_by(annee, academie) %>% summarise(salaire_brut_annuel_estime = mean(salaire_brut_annuel_estime))



# Define server logic required to draw a histogram
function(input, output, session) {
  output$dataTable <- renderDataTable(data)
  
  # output$mymap <- renderLeaflet({
  #   leaflet(df) %>%
  #     addTiles() %>%
  #     setView(lng = 2.2137, lat = 46.2276, zoom = 6) %>% 
  #     addCircleMarkers(
  #       lng = ~long,
  #       lat = ~lat,
  #       radius = 6,
  #       color = "blue",
  #       fillOpacity = 0.8,
  #       popup = ~paste("<strong>Académie :</strong>", academie, "<br>",
  #                      "<strong>Taux de réponse moyen :</strong>", round(taux_reponse_totale), "%", "<br>",
  #                      "<strong>Taux d'insertion moyen :</strong>", round(taux_insertion_moyen), "%")
  #     )
  # })
  
  output$evolutionPlot <- renderPlot({
    if (input$variable == "salaire_brut_annuel_estime"){
      data2 <- data[!is.na(salaire_brut_annuel_estime)]
      data2 <- data2 %>% group_by(annee, academie) %>% summarise(salaire_brut_annuel_estime = mean(salaire_brut_annuel_estime))
    }
    else if (input$variable == "taux_d_insertion"){
      data2 <- data[!is.na(taux_d_insertion)]
      data2 <- data2 %>% group_by(annee, academie) %>% summarise(taux_d_insertion = mean(taux_d_insertion))
    }
    
    filtered_data <- data2 %>% filter(academie %in% input$academie)
    
    ggplot(filtered_data, aes(x=annee, y=salaire_brut_annuel_estime, color=academie)) +
      geom_line(size=1) +
      geom_point(size = 2) +
      labs(y = "Salaire (€)",
           x = "Année",
           color = "Académie") +
      theme_minimal() +
      theme(legend.position = "bottom")
  })
  
  
}
