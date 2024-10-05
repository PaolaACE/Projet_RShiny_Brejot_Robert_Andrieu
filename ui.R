library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)

source("Import_donnees.R")

dashboardPage(
  
  # Titre de la page
  dashboardHeader(title = "Étude de l'insertion après l'obtention d'un diplôme",
                  titleWidth = 700),
  
  # Sidebar (barre latérale)
  dashboardSidebar(
    sidebarMenu(
      menuItem("Présentation", tabName = "presentation", icon = icon("table")),
      menuItem("Graphiques", tabName = "graph", icon = icon("chart-bar")),
      menuItem("Salaires", tabName = "salaire", icon = icon("euro-sign"))
    )
  ),
  
  # Corps de la page
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    tabItems(
      
      # Tab présentation
      tabItem(
        tabName = "presentation",
        fluidRow(
          box(
            width = 3,
            selectInput(
              inputId = "var", label = "Sélectionnez des variables à visualiser : ", multiple = TRUE,
              choices = colnames(data), selected = c("annee", "etablissement", "discipline", "nombre_de_reponses")
            )
          ),
          box(width = 9, dataTableOutput(outputId = "dataTable"))
        )
      ),
      
      # Tab Graphiques
      tabItem(
        tabName = "graph",
        fluidRow(
          box(
            width = 3,
            selectInput(
              inputId = "varnum", label = "Sélectionnez la variable en ordonnée :",
              choices = colnames(data)[sapply(data, is.numeric)],
              selected = "annee"
            )
          ),
          box(width = 9, plotOutput("boxplot"))
        )
      ),
      
      # Tab Salaires
      tabItem(
        tabName = "salaire",
        fluidRow(
          box(title = "Salaires par académie",collapsible = TRUE, collapsed = TRUE,
            width = 12, plotOutput("salaire_ac")),
          box(title = "Répartition des salaires", collapsible = TRUE, collapsed = TRUE,
            width = 12, plotOutput("rep_salaires"))
        )
      )
    )
  )
)