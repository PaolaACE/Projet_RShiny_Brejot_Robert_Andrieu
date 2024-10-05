#

library(data.table)
library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
  data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
                header = TRUE, sep = ";", stringsAsFactors = TRUE)
  
  #on ne garde que les variables qui présentent un intérêt
  #et on évite les redondances
  
  dta_trie <- data[,c(1,4,7,9,11,17,18,24,30)]
  
  #on retire les tirets car R les voit comme des signes moins
  
  dta_trie[academie == "Aix-Marseille", academie := "Aix_Marseille"]
  dta_trie[academie == "Clermont-Ferrand", academie := "Clermont_Ferrand"]
  dta_trie[academie == "Nancy-Metz", academie := "Nancy_Metz"]
  dta_trie[academie == "Orléans-Tours", academie := "Orleans_Tours"]
  
  #on retire les lignes "résumées" car elles biaiseront l'analyse
  
  dta_trie <- dta_trie[etablissement != "Toutes universités et établissements assimilés"]

  observeEvent(input$Go, {
    # a1 <- reactive({input$an[1]})
    # A1 <- as.numeric(a1)
    # a2 <- reactive({input$an[2]})
    # A2 <- as.numeric(a2)
    # res.aov <- c()
    # for (a in A1:A2){
    #   
    #   dta_a <- dta_trie[year==a]
    #   mod <- glm(input$Y ~ input$geo + input$sujet + femmes +
    #                input$geo:input$sujet +
    #                input$geo:femmes+
    #                input$sujet:femmes, data = dta_a)
    #   res.aov <- c(res.aov, 
    #                summary(Anova(mod, type = "III")))
    
    A <- reactive({input$an[1]})
    a <- as.numeric(A())
    
    dta_trie <- dta_trie[annee == a]
    
    Geo <- (reactive({input$geo}))
    g <- as.numeric(Geo())
    G <- dta_trie[,..g][[1]]
    
    Suj <- reactive({input$sujet})
    s <- as.numeric(Suj())
    S <- dta_trie[,..s][[1]]
    
    YA <- reactive({input$Y})
    y <- as.numeric(YA())
    Y <- dta_trie[,..y][[1]]
    
    F <- dta_trie$femmes
    
    mod <- lm(Y~G + S + F +
                 G:S + G:F + S:F +
                 G:S:F)
    res.aov <- summary(Anova(mod, type = "III"))
    

    output$aov <- renderPrint({res.aov})
    
  })

}
