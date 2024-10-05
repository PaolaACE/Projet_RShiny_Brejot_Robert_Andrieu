#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

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
            choiceValues = list("salaire_brut_annuel_estime",
                                "taux_d_emploi", 
                                "taux_dinsertion"), 
            selected = 1
          ),
          
          radioButtons(
            inputId = "geo",
            label = "Niveau geographique",
            choiceNames = list("Académie", "Etablissement"),
            choiceValues = list("academie", "etablissement"), 
            selected = 1
          ),
          
          radioButtons(
            inputId = "sujet",
            label = "Niveau de précision du sujet",
            choiceNames = list("Domaine (5)", "Discipline(20)"),
            choiceValues = list("domaine", "discipline"), 
            selected = 1
          ), 
          
          sliderInput(
            inputId = "an",
            label = "Sur quelle période? ",
            value = c(2010, 2020),
            min = 2010, 
            max = 2020, 
            round = TRUE, 
            step = 1, 
          )
        ), 
        sidebarPanel(
          title = "Analyses de la variance sur la période souhaitée",
          width = 15,
          #textOutput(outputId = aov)
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


