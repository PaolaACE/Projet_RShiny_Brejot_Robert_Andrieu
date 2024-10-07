#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
fluidPage(
  
  navbarPage(
    title = "Etude de l'insertion après l'obtention d'un diplome",
    tabPanel(
      title = "Présentation",
      dataTableOutput(outputId = "dataTable"),
      leafletOutput("mymap", width = "100%", height = 600)
    ),
    
    tabPanel(
      title = "Evolution temporelle",
      selectInput("academie", "Choisir les academies : ",
                  choices = unique(data2$academie),
                  selected = "Rennes",
                  multiple = T),
      
      selectInput("variable", "Choisir la variable : ",
                choices = list("salaire_brut_annuel_estime", "taux_dinsertion"),
                selected = "salaire_brut_annuel_estime"),
      
      plotOutput("evolutionPlot")
      
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
  )
)


