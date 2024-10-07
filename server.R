
function(input, output, session) {
  
  # Sortie tableau des données
  output$dataTable <- DT::renderDT(data[,input$var, with = FALSE])
  
  # Boxplot des données quantitatives par domaine
  output$boxplot <- renderPlot({
    ggplot(data, aes(x = domaine, y = get(input$varnum))) +
      geom_boxplot() +
      labs(
        title = paste("Répartition de", input$varnum, "par domaine"),
        x = "Domaine", y = input$varnum
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Salaire brut annuel moyen estimé par académie
  output$salaire_ac <- renderPlot({
    varfac = as.character(input$varfac)
    salaire_col = input$salaire
    moyenne_par_academie <- data[, .(moyenne_salaire = mean(get(salaire_col), na.rm = TRUE)), by = varfac]
    
    ggplot(moyenne_par_academie, aes_string(x = varfac, y = "moyenne_salaire")) +
      geom_bar(stat = "identity", fill = "#0073B2", color = "black", width = 0.7) +
      labs(
        title = paste("Salaire moyen estimé par", varfac, "pour", salaire_col),
        x = varfac, y = paste(salaire_col, "(€)")
      ) +
      geom_text(aes(label = round(moyenne_salaire, 0)),  
                position = position_stack(vjust = 0.5), 
                color = "white") +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title.x = element_text(size = 14, face = "bold"),
        axis.title.y = element_text(size = 14, face = "bold")
      )
  })
  
  # Carte Leaflet
  output$mymap <- renderLeaflet({
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
  })
  
  # Graphique d'évolution temporelle
  output$evolutionPlot <- renderPlot({
    data2 <- if (input$variable == "salaire_brut_annuel_estime") {
      data[!is.na(salaire_brut_annuel_estime)] %>%
        group_by(annee, academie) %>%
        summarise(value = mean(salaire_brut_annuel_estime))
    } 
    else if (input$variable == "taux_dinsertion") {
      data[!is.na(taux_dinsertion)] %>%
        group_by(annee, academie) %>%
        summarise(value = mean(taux_dinsertion))
    }
    else if (input$variable == "taux_de_reponse"){
      data[!is.na(taux_de_reponse)] %>%
        group_by(annee, academie) %>%
        summarise(value = mean(taux_de_reponse))
    }
    
    filtered_data <- data2 %>% filter(academie %in% input$academie)
    
    titre <- if(input$variable == "salaire_brut_annuel_estime"){
      "Salaire (€)"
    } else if (input$variable == "taux_dinsertion"){
      "Taux d'insertion (%)"
    } else if (input$variable == "taux_de_reponse"){
      "Taux de réponse (%)"
    }
      
    ggplot(filtered_data, aes(x = annee, y = value, color = academie)) +
      geom_line(size = 1) +
      geom_point(size = 2) +
      labs(y = titre,
           x = "Année",
           color = "Académie") +
      theme_minimal() +
      theme(legend.position = "bottom") +
      scale_x_continuous(breaks = seq(min(filtered_data$annee), max(filtered_data$annee), by = 1))+
      scale_y_continuous(
        breaks = if (input$variable == "salaire_brut_annuel_estime") {
          seq(0, max(filtered_data$value, na.rm = TRUE), by = 1000)
        } else {
          seq(round(min(filtered_data$value)), 100, by = 1)
        }
      )
  })
}

