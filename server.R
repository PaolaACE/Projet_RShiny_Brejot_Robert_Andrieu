source("Import_donnees.R")

# Define server logic required to draw a histogram
function(input, output, session) {
  output$dataTable <- renderDataTable(data)
  output$salaire_ac <- renderPlot({
    ggplot(data, aes(x = academie, y = salaire_brut_annuel_estime, fill = academie)) +
      geom_bar(stat = "identity") +
      labs(title = "Salaire brut annuel estimé par académie", x = "Académie", y = "Salaire brut annuel (€)") +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
  output$rep_salaires <- renderPlot({
    ggplot(data, aes(x = salaire_net_median_des_emplois_a_temps_plein)) +
      geom_histogram(binwidth = 50, fill = "blue", color = "white") +
      labs(title = "Distribution des salaires nets médians des emplois à temps plein",
           x = "Salaire net médian (€)", y = "Fréquence")
  })
}
