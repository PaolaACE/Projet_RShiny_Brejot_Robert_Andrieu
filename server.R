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

  observeEvent(input$Go, {
    # a1 <- reactive({input$an[1]})
    # a2 <- reactive({input$an[2]})
    # for (a in a1:a2){
    #   print(a)
    #   dta_a <- dta_trie[year==a]
    #   mod <- glm(input$Y ~ input$geo + input$sujet + femmes +
    #                input$geo:input$sujet +
    #                input$geo:femmes+
    #                input$sujet:femmes, data = dta_a)
    #   res.aov <- c(res.aov, 
    #                summary(Anova(mod, type = "III")))
    
    a <- as.character(reactive({input$an[1]}))
    geog <- reactive({input$geo})
    sujet <- as.character(reactive({input$sujet}))
    Y <- as.character(reactive({input$Y}))

    print(a)
    mod <- glm(Y ~ geo + sujet + femmes +
                  geo:sujet +
                  geo:femmes+
                  sujet:femmes, data = dta_trie)
    res.aov <- summary(Anova(mod, type = "III"))
    
    
    output$aov <- renderPrint({res.aov})
    
  })

}
