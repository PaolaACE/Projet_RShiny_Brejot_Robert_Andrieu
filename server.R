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
    
    #Fe <- dta_trie$femmes
    #Fe <- as.numeric(Fe)
    #F0 <- rep(NA, length(Fe))
    
    podium_vide <- rep(NA, times = 10)
    podium_geo <- data.frame(position = c(1:10))
    podium_suj <- data.frame(position = c(1:5))
    
    iter = 1
    
    res.em <- c()
    
    for (a in A1:A2){
      
      # on ne considere qu'une annee
      
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
      
      #on etablit le modele a l'aide de la fonction lm

      mod <- lm(Y~G + S + G:S)
      
      #on cherche alors a selectionner les "classements" des meilleurs en 
      #terme de geographie et de sujet d'études pour la variable sélectionnee
      
      em_G <- emmeans(mod, ~G)
      em_S <- emmeans(mod, ~S)
      
      em_G <- data.frame(em_G)
      em_S <- data.frame(em_S)
      
      em_G <- data.table(em_G)
      em_S <- data.table(em_S)
      
      em_G <- em_G[order(emmean), ]
      em_S <- em_S[order(emmean), ]
      
      pod_G <- em_G[c(1:10),]
      pod_S <- em_S[c(1:5),]
      
      pod_G <- data.frame(pod_G)
      pod_S <- data.frame(pod_S)
      
      pod_G <- pod_G[,1]
      pod_S <- pod_S[,1]
      
      podium_geo <- cbind(podium_geo, pod_G)
      podium_suj <- cbind(podium_suj, pod_S)
    }
    
    #on renomme les colonnes pour la lisibilité
    
    colnames(podium_geo)[-1]<- seq(from=A1, to = A2, by = 1)
    colnames(podium_suj)[-1]<- seq(from=A1, to = A2, by = 1)
    
    #on stocke ces classements dans des outputs
    
    output$res_geo <- renderTable({podium_geo})
    output$res_suj <- renderTable({podium_suj})
    
  })
  
  #analyse AFC ----

  observeEvent(input$Hop, {

    #on recupere les valeurs des index des parametres rentres par l'utilisateur

    Geo_AFC <- (reactive({input$geo_AFC}))
    geo_AFC <- as.numeric(Geo_AFC())

    Suj_AFC <- (reactive({input$suj_AFC}))
    suj_AFC <- as.numeric(Suj_AFC())

    An_AFC <- (reactive({input$an_AFC}))
    an_AFC <- as.numeric(An_AFC())
    
    #on ne garde ici que les variables d'interet: 
    #domaine et discipline pour le sujet
    #academie et etablissement pour le niveau geographique
    #et le nombre de reponses comme indicateur de la population
    
    data_AFC <- data[annee == an_AFC, c(4,7,9,11,14)]
    
    #on cree alors des variables portant des noms connus pour pouvoir les 
    #manipuler (conditionner dessus)
    
    geo <- data_AFC[,..geo_AFC][[1]]
    data_AFC[, geographie := geo]
    
    suj <- data_AFC[,..suj_AFC][[1]]
    data_AFC[, sujet := suj]
    
    #on stocke les modalites des variables pour pouvoir iterer dessus
    
    modalites_suj <- levels(data_AFC[,sujet])
    modalites_geo <- levels(data_AFC[,geographie])
    
    I <- length(modalites_geo)
    J <- length(modalites_suj)
    
    #on cree une matrice de contingence vide que l'on remplira
     
    Conting <- matrix(data=NA, nrow = J, ncol = I)

    for (i in 1:I){
      for (j in 1:J){
        #on stocke les modalites associees en terme de sujet et de geographie
        mod_i <- as.character(modalites_geo[i])
        mod_j <- as.character(modalites_suj[j])
        dta_eph <- data_AFC[(geographie==mod_i)&(sujet==mod_j), nombre_de_reponses]
        #on somme, pour les observations qui possedent ces modalites, le nombre
        #de reponses
        donnee <- sum(dta_eph)
        Conting[j, i] <- donnee
      }
    }

    tab_conting <- data.frame(Conting)
    
    rownames(tab_conting) <- as.character(modalites_suj)
    colnames(tab_conting) <- as.character(modalites_geo)
    
    output$Conting <- renderTable({tab_conting})
    
    AFC <- CA(tab_conting)
    plot_AFC <-plot(AFC)
    output$plot_AFC <- renderPlot({plot_AFC})
    
    })
  
}

