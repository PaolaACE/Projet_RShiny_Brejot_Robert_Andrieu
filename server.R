
function(input, output, session) {
  
  # Sortie tableau des données ----
  output$dataTable <- DT::renderDataTable({
    DT::datatable(
      data[,input$var, with = FALSE],
      options = list(
        scrollX = TRUE
      )
    )
  })
  
  # Boxplot des données quantitatives par domaine ----
  output$boxplot <- renderPlot({
    ggplot(data, aes(x = domaine, y = get(input$varnum))) +
      geom_boxplot() +
      labs(
        title = paste("Répartition de", input$varnum, "par domaine"),
        x = "Domaine", y = input$varnum
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Salaire brut annuel moyen estimé par académie ----
  output$salaire_ac <- renderPlot({
    varfac = as.character(input$varfac)
    salaire_col = input$salaire
    moyenne_par_varfac <- data[, .(moyenne_salaire = mean(get(salaire_col), na.rm = TRUE)), by = varfac]
    
    ggplot(moyenne_par_varfac, aes_string(x = varfac, y = "moyenne_salaire")) +
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
  
  # Graphique d'évolution temporelle ----
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
  
  # Analyse Factorielle des correspondances entre Localisation et Domaine ----
  observeEvent(input$Hop, {
    
    # On récupère les valeurs des index
    Geo_AFC <- as.numeric(input$geo_AFC)
    Suj_AFC <- as.numeric(input$suj_AFC)
    An_AFC <- as.numeric(input$an_AFC)
    
    # On filtre les données
    data_AFC <- data[annee == An_AFC, c(4, 7, 9, 11, 14)]
    
    geo <- data_AFC[, ..Geo_AFC][[1]]
    data_AFC[, geographie := geo]
    
    suj <- data_AFC[, ..Suj_AFC][[1]]
    data_AFC[, sujet := suj]
    
    modalites_suj <- levels(data_AFC[, sujet])
    modalites_geo <- levels(data_AFC[, geographie])
    
    I <- length(modalites_geo)
    J <- length(modalites_suj)
    
    Conting <- matrix(data = NA, nrow = J, ncol = I)
    
    for (i in 1:I) {
      for (j in 1:J) {
        mod_i <- as.character(modalites_geo[i])
        mod_j <- as.character(modalites_suj[j])
        dta_eph <- data_AFC[(geographie == mod_i) & (sujet == mod_j), nombre_de_reponses]
        donnee <- sum(dta_eph)
        Conting[j, i] <- donnee
      }
    }
    
    tab_conting <- data.frame(Conting)
    rownames(tab_conting) <- as.character(modalites_suj)
    colnames(tab_conting) <- as.character(modalites_geo)
    
    # Tableau de contingence
    output$Conting <- DT::renderDataTable({
      DT::datatable(
        tab_conting,
        options = list(
          scrollX = TRUE
        )
      )
    })
    
    AFC <- CA(tab_conting)
    
    # Graphe de l'AFC 
    output$plot_AFC <- renderPlot({
      fviz_ca_biplot(AFC, repel = TRUE) +
        theme_minimal() +
        ggtitle("Analyse Factorielle des Correspondances")
    })
  })
  
  
  # Analyse Factorielle des correspondances entre Localisation et Salaire ----
  observeEvent(input$Tac, {
    
    # Créer les intervalles basés sur les quantiles
    data$salaire_categ_quantiles <- cut(data$salaire_brut_annuel_estime, 
                                        breaks = quantile(data$salaire_brut_annuel_estime, 
                                                          probs = c(0, 1/3, 2/3, 1), 
                                                          na.rm = TRUE),
                                        labels = c("Faible", "Moyen", "Élevé"), 
                                        include.lowest = TRUE)
    
    # Vérifier la répartition des effectifs dans chaque catégorie
    table(data$salaire_categ_quantiles)
    
    # On récupère les valeurs des index
    Var_AFC <- as.numeric(input$var_AFC)
    An_AFC <- as.numeric(input$annee_AFC)
    
    # On filtre les données
    data_AFC <- data[annee == An_AFC,c(4, 7, 9, 11, 14,36)]
    
    var <- data_AFC[, ..Var_AFC][[1]]
    data_AFC[, variable_int := var]
    
    
    modalites_sal <- levels(data_AFC$salaire_categ_quantiles)
    modalites_suj <- levels(data_AFC[, variable_int])
    
    I <- length(modalites_sal)
    J <- length(modalites_suj)
    
    Conting <- matrix(data = NA, nrow = J, ncol = I)
    
    for (i in 1:I) {
      for (j in 1:J) {
        mod_i <- as.character(modalites_sal[i])
        mod_j <- as.character(modalites_suj[j])
        dta_eph <- data_AFC[(salaire_categ_quantiles == mod_i) & (variable_int == mod_j), nombre_de_reponses]
        donnee <- sum(dta_eph)
        Conting[j, i] <- donnee
      }
    }
    
    tab_conting <- data.frame(Conting)
    rownames(tab_conting) <- as.character(modalites_suj)
    colnames(tab_conting) <- as.character(modalites_sal)
    
    # Tableau de contingence
    output$Contingence <- DT::renderDataTable({
      DT::datatable(
        tab_conting,
        options = list(
          scrollX = TRUE
        )
      )
    })
    
    AFC <- CA(tab_conting)
    
    # Graphe de l'AFC
    output$plot_AFC_locsal <- renderPlot({
      fviz_ca_biplot(AFC, repel = TRUE) +
        theme_minimal() +
        ggtitle("Analyse Factorielle des Correspondances")
    })
    
  })
  
  observeEvent(input$Go, {
    
    # Période sélectionnée par l'utilisateur
    A1 <- as.numeric(input$an[1])
    A2 <- as.numeric(input$an[2])
    
    podium_geo <- data.frame(position = c(1:10))
    podium_suj <- data.frame(position = c(1:5))
    
    for (a in A1:A2) {
      # Filtrer les données par année
      dta_a <- dta_trie[annee == a, ]
      
      # Variables géographique et sujet
      g <- as.numeric(input$geo)
      s <- as.numeric(input$sujet)
      G <- dta_a[, ..g][[1]]
      S <- dta_a[, ..s][[1]]
      
      # Variable dépendante (Y)
      y <- as.numeric(input$Y)
      Y2 <- dta_a[, ..y][[1]]
      Y <- as.numeric(as.character(Y2))
      
      # Modèle linéaire
      mod <- lm(Y ~ G + S + G:S)
      
      # Effectuer les comparaisons (emmeans)
      em_G <- emmeans(mod, ~G)
      em_S <- emmeans(mod, ~S)
      
      # Conversion en data.frame
      em_G_df <- as.data.frame(em_G)
      em_S_df <- as.data.frame(em_S)
      
      # Organiser les résultats par géographie et sujet
      em_G <- data.table(em_G_df)[order(emmean), ]
      em_S <- data.table(em_S_df)[order(emmean), ]
      
      podium_geo <- cbind(podium_geo, em_G[1:10, 1])
      podium_suj <- cbind(podium_suj, em_S[1:5, 1])
    }
    
    colnames(podium_geo)[-1] <- seq(A1, A2)
    colnames(podium_suj)[-1] <- seq(A1, A2)
    
    # Afficher les résultats dans les tableaux
    output$res_geo <- DT::renderDataTable({
      DT::datatable(
        podium_geo,
        options = list(
          scrollX = TRUE
        )
      )
    })
    output$res_suj <- DT::renderDataTable({
      DT::datatable(
        podium_suj,
        options = list(
          scrollX = TRUE
        )
      )
    })
  })
  
  
}

