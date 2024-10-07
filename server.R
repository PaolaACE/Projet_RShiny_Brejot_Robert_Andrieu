#

library(data.table)
library(shiny)
library(car)
library(FactoMineR)
library(Factoshiny)
library(emmeans)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  #analyse anova ----
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
    
    a1 <- reactive({input$an[1]})
    A1 <- as.numeric(a1())
    a2 <- reactive({input$an[2]})
    A2 <- as.numeric(a2())
    
    #on stockera les resultats des anova dans res.aov
    Geo <- (reactive({input$geo}))
    g <- as.numeric(Geo())
    G <- dta_trie[,..g][[1]]
    noms_g <- levels(G)
    
    Suj <- reactive({input$sujet})
    s <- as.numeric(Suj())
    S <- dta_trie[,..s][[1]]
    noms_s <- levels(s)
    
    YA <- reactive({input$Y})
    y <- as.numeric(YA())
    Y2 <- dta_trie[,..y][[1]]
    Y2 <- as.character(Y2)
    Y <- sapply(Y2, as.numeric)
    
    Fe <- dta_trie$femmes
    Fe <- as.numeric(Fe)
    F0 <- rep(NA, length(Fe))
    
    coeffs_geo <- data.frame(lieu = noms_g)
    coeffs_suj <- data.frame(sujet = noms_s)
    iter = 1
    
    res.em <- c()
    
    for (a in A1:A2){
        # on considère les donnees annee par annee entre les deux annees 
      #selectionnees
      iter <- iter+1
      dta_a <- dta_trie[annee==a,]
      
      #on cree des listes liees aux parametres selectionnes par l'utilisateur

      Geo <- (reactive({input$geo}))
      g <- as.numeric(Geo())
      G <- dta_a[,..g][[1]]

      Suj <- reactive({input$sujet})
      s <- as.numeric(Suj())
      S <- dta_a[,..s][[1]]

      YA <- reactive({input$Y})
      y <- as.numeric(YA())
      Y2 <- dta_a[,..y][[1]]
      Y2 <- as.character(Y2)
      Y <- sapply(Y2, as.numeric)

      Fe <- dta_a$femmes
      Fe <- as.numeric(Fe)
      F0 <- rep(NA, length(Fe))

      #on etablit alors le modele
      if (identical(Fe,F0)){
         #si F n'a que des NA, alors le taux de femmes n'a pas ete mesure
         #le modele est donc construit sans cette variable

         mod <- glm(Y~G + S +
                 G:S)
      }
      else{
         #si le taux de femmes a ete mesure, alors on le fait rentrer dans le
         #modele
         mod <- glm(Y~G + S + Fe+
                     G:S + G:Fe + S:Fe +
                     G:S:Fe)
      }
      # coeffs_geo[,iter+1] <- emmeans(mod, ~G)[,4]
      # coeffs_suj[,iter+1] <- emmeans(mod, ~S)[,4]
      em <- emmeans(mod, ~G)
      }
    
    output$res <- renderPrint({em})
    
  })
  
  #analyse AFC ----

  observeEvent(input$Hop, {

    #on recupere les valeurs des index

    Geo_AFC <- (reactive({input$geo_AFC}))
    geo_AFC <- as.numeric(Geo_AFC())

    Suj_AFC <- (reactive({input$suj_AFC}))
    suj_AFC <- as.numeric(Suj_AFC())

    An_AFC <- (reactive({input$an_AFC}))
    an_AFC <- as.numeric(An_AFC())
    
    data_AFC <- data[annee == an_AFC, c(4,7,9,11,14)]

    I <- length(levels(data_AFC[, ..geo_AFC][[1]]))
    J <- length(levels(data_AFC[, ..suj_AFC][[1]]))

    Conting <- matrix(data=NA, nrow = I, ncol = J)

    for (i in 1:I){
      for (j in 1:J){
        #on stocke les modalites associees en terme de sujet et de geographie
        mod_i <- levels(data_AFC[,..geo_AFC][[1]])[i]
        mod_j <- levels(data_AFC[,..suj_AFC][[1]])[j]
        dta_eph <- data_AFC[..suj_AFC == mod_i&..geo_AFC == j]
        donnee <- sum(dta_eph[,nombre_de_reponses])
        Conting[i, j] <- donnee
      }
    }

    tab_conting <- data.frame(Conting)
    colnames(tab_conting) <- levels(data_AFC[, ..geo_AFC])
    rownames(tab_conting) <- levels(data_AFC[, ..suj_AFC])
    output$Conting <- renderTable({Conting})
    #CFA(tab_conting)
    })
  
}


