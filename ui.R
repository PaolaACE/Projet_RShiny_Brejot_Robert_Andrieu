

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
    tabPanel(
      title = "Analyse AFC",
      sidebarLayout(
        sidebarPanel(
          title = "Paramètres",
          width = 5,
          
          radioButtons(
            inputId = "geo_AFC",
            label = "Niveau geographique",
            choiceNames = list("Académie", "Etablissement"),
            choiceValues = list(3, 2), 
            selected = 1
          ),
          
          radioButtons(
            inputId = "sujet_AFC",
            label = "Niveau de précision du sujet",
            choiceNames = list("Domaine (5)", "Discipline(20)"),
            choiceValues = list(4,5), 
            selected = 1
          ), 
          
          sliderInput(
            inputId = "an_AFC",
            label = "En quelle année?",
            value = 2015,
            min = 2010, 
            max = 2020, 
            round = TRUE, 
            step = 1
          ), 
          actionButton(
            inputId = "Hop", 
            label = "Lancer l'AFC"
          )
        ), 
        sidebarPanel(
          title = "Analyses Factorielle des Correspondances",
          width = 20,
          #tableOutput(outputId = conting)
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


