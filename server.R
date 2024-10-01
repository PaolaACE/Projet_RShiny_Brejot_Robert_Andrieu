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

# Define server logic required to draw a histogram
function(input, output, session) {
  data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
                header = TRUE, sep = ";", stringsAsFactors = TRUE)
  
  #on ne garde que les variables qui présentent un intérêt
  #et on évite les redondances
  
  data_trie <- data[,c(2,4, 7, 9, 11, 15, 17, 18, 19, 20, 21, 
                       22, 23, 24, 25, 26, 27, 28, 29, 30)]
  
  #on retire les tirets car R les voit comme des signes moins
  
  dta_trie[academie == "Aix-Marseille", academie := "Aix_Marseille"]
  dta_trie[academie == "Clermont-Ferrand", academie := "Clermont_Ferrand"]
  dta_trie[academie == "Nancy-Metz", academie := "Nancy_Metz"]
  dta_trie[academie == "Orléans-Tours", academie := "Orleans_Tours"]
  
  #on retire les lignes "résumées" car elles biaiseront l'analyse
  
  dta_trie <- dta_trie[etablissement != "Toutes universités et établissements assimilés"]
  output$dataTable <- renderDataTable(data)
  
  for (a in input$an[1]:input$an[2]){
    print(a)
    mod <- glm(input$Y ~ input$geo + input$sujet + femmes +
                 input$geo:input$sujet +
                 input$geo:femmes+
                 input$sujet:femmes, data = dta)
    res.aov <- c(res.aov, "annee suuviante", 
                 summary(Anova(mod, type = "III")))
  }
  output$res.aov <- res.aov
}
