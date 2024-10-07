function(input, output, session) {
  
  # Tableau des données sélectionnées
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
    
    print(varfac)
    
    # Calculer le salaire moyen par le facteur sélectionné
    moyenne_par_academie <- data[, .(moyenne_salaire = mean(get(salaire_col), na.rm = TRUE)), by = varfac]
    
    # Création du graphique à barres
    ggplot(moyenne_par_academie, aes_string(x = varfac, y = "moyenne_salaire")) +
      geom_bar(stat = "identity", fill = "#0073B2", color = "black", width = 0.7) +
      labs(
        title = paste("Salaire moyen estimé par", varfac, "pour", salaire_col),  # Titre dynamique basé sur les variables
        x = varfac,
        y = paste(salaire_col, "(€)")  
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
  output$rep_salaires <- renderPlot({
    selected_column <- as.character(input$varfac)
    # Création du graphique à barres pour la variable catégorielle
    ggplot(data, aes_string(x = selected_column), weight = "nombre_de_reponses") +
      geom_bar(fill = "#0073B2", color = "white") +
      labs(
        title = paste("Nombre de réponses pour ", selected_column),
        x = selected_column, 
        y = "Fréquence"
      ) +
      geom_text(stat = "count", aes(label = ..count..), vjust = -0.5, color = "black") +  # Étiquettes de fréquence
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title.x = element_text(size = 14, face = "bold"),
        axis.title.y = element_text(size = 14, face = "bold")
      )
  })
  
}