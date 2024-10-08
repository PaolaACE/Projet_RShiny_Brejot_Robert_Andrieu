library(Factoshiny)

#ui ----

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  
  navbarPage(
    title = "Etude de l'insertion après l'obtention d'un diplome",
    tabPanel(
      title = "Présentation",
      dataTableOutput(outputId = "dataTable")
    ),
    
    mainPanel(
      title = "Test"
    ),
    
    tabPanel(
      title = "Emplois par domaines"
    ),
    
    tabPanel(
      title = "Analyse",
      sidebarLayout(
        sidebarPanel(
          title = "Paramètres",
          width = 5,
          
          radioButtons(
            inputId = "Y",
            label = "Quelle variable étudier?",
            choiceNames = list("Salaire brut annuel estimé", 
                               "Taux d'emploi", 
                               "Taux d'insertion"),
            choiceValues = list(8, 7, 6), 
            selected = 1
          ),
          
          radioButtons(
            inputId = "geo",
            label = "Niveau geographique",
            choiceNames = list("Académie", "Etablissement"),
            choiceValues = list(3, 2), 
            selected = 1
          ),
          
          radioButtons(
            inputId = "sujet",
            label = "Niveau de précision du sujet",
            choiceNames = list("Domaine (5)", "Discipline(20)"),
            choiceValues = list(4,5), 
            selected = 1
          ), 
          
          sliderInput(
            inputId = "an",
            label = "Sur quelle période? ",
            value = c(2010, 2020),
            min = 2010, 
            max = 2020, 
            round = TRUE, 
            step = 1
          ), 
          actionButton(
            inputId = "Go", 
            label = "Lancer les analyses"
          )
        ), 
        sidebarPanel(
          title = "Analyses de la variance sur la période souhaitée",
          width = 20,
          verbatimTextOutput(outputId = "aov")
        )
      )
    ),
    
    
    navbarMenu(
      title = "Salaires",
      tabPanel(
        title = "Par domaines"
      ),
      tabPanel(
        title = "Par emploi"
      ), 
      tabPanel(
        title = "Analyse")
    )
  )
  
)

# server ----

# 

library(data.table)
library(shiny)
library(car)

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
    
    #code qui devrait devenir le final ----
    a1 <- reactive({input$an[1]})
    A1 <- as.numeric(a1())
    a2 <- reactive({input$an[2]})
    A2 <- as.numeric(a2())
    
    #on stockera les resultats dans res.aov
    
    res.aov <- c()
    
    for (a in A1:A2){
      # on considère les donnees annee par annee
      
      dta_a <- dta_trie[annee==a]
      
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
      
      res.aov <- c(res.aov, a,
                   anova(mod))
    }
    
    #test seulement sur une annee MARCHE ----
    # 
    # A <- reactive({input$an[1]})
    # a <- as.numeric(A())
    # 
    # dta_trie <- dta_trie[annee == a]
    # 
    #On selectionne les vecteurs sur lesquels on fera l'analyse
    #a partir des parametres rentres par l'utilisateur
    # 
    # Geo <- (reactive({input$geo}))
    # g <- as.numeric(Geo())
    # G <- dta_trie[,..g][[1]]
    # 
    # Suj <- reactive({input$sujet})
    # s <- as.numeric(Suj())
    # S <- dta_trie[,..s][[1]]
    # 
    # YA <- reactive({input$Y})
    # y <- as.numeric(YA())
    # Y2 <- dta_trie[,..y][[1]]
    # Y2 <- as.character(Y2)
    # Y <- sapply(Y2, as.numeric)
    # 
    # F <- dta_trie$femmes
    # F <- as.numeric(F)
    # 
    # #on etablit alors le modele (ne marche pas avec 2010 car les femmes sont que
    # #des NA)
    # mod <- glm(Y~G + S + F+
    #              G:S + G:F + S:F +
    #             G:S:F)
    # res.aov <- anova(mod)
    
    
    output$aov <- renderPrint({res.aov})
    
    
  })
  
  
}
Factoshiny(data)
