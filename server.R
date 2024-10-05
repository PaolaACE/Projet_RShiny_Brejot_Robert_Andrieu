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
    moyenne_par_academie <- data[, .(moyenne_salaire = mean(salaire_brut_annuel_estime, na.rm = TRUE)), by = academie]
    ggplot(moyenne_par_academie, aes(x = academie, y = moyenne_salaire, fill = academie)) +
      geom_bar(stat = "identity") +
      labs(
        title = "Salaire brut annuel moyen estimé par académie", 
        x = "Académie", y = "Salaire brut annuel (€)"
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  
  # Distribution des salaires nets médians des emplois à temps plein
  output$rep_salaires <- renderPlot({
    ggplot(data, aes(x = salaire_net_median_des_emplois_a_temps_plein)) +
      geom_histogram(binwidth = 50, fill = "blue", color = "white") +
      labs(
        title = "Distribution des salaires nets médians des emplois à temps plein",
        x = "Salaire net médian (€)", y = "Fréquence"
      )
  })
}