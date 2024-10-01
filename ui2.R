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
    
    tabPanel(
      title = "Emplois par domaines"
    ),
    
    navbarMenu(
      title = "Salaires",
      tabPanel(
        title = "Par domaines"
      ),
      tabPanel(
        title = "Par emploi"
      )
    )
  ), 
  
  mainPanel(
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput(
          inputId = "geo",
          label = "Niveau geographique",
          choiceNames = list("Académie", "Etablissement"),
          choiceValues = list("academie", "etablissement")
        ),
        
        checkboxGroupInput(
          inputId = "sujet",
          label = "Niveau de précision du sujet",
          choiceNames = list("Domaine (5)", "Discipline(20)"),
          choiceValues = list("domaine", "discipline")
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
        
      )
    )

    
  )
)


