library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(leaflet)
library(dplyr) 
library(tidygeocoder)

source("Import_donnees.R")

dashboardPage(
  
  # Titre de la page
  dashboardHeader(title = "Étude de l'insertion après l'obtention d'un diplôme", titleWidth = 700),
  
  # Sidebar (barre latérale)
  dashboardSidebar(
    sidebarMenu(
      menuItem("Présentation", tabName = "presentation", icon = icon("info-circle")),
      menuItem("Données", tabName = "donnees", icon = icon("table")),
      menuItem("Graphiques", tabName = "graph", icon = icon("chart-bar")),
      menuItem("Salaires", tabName = "salaire", icon = icon("euro-sign")),
      menuItem("Évolution temporelle", tabName = "evolution", icon = icon("line-chart")),
      menuItem("Carte", tabName = "carte", icon = icon("map")) 
    )
  ),
  
  # Corps de la page
  dashboardBody(
    tabItems(
      
      #Onglet Présentation
      tabItem(tabName = "presentation",
              h1("Bienvenue dans l'application !"),
              p("Cette application a pour but de démontrer comment utiliser shinydashboard.")
      ),
      
      # Onglet Données
      tabItem(tabName = "donnees",
              fluidRow(
                box(width = 3, selectInput("var", "Sélectionnez des variables à visualiser : ", multiple = TRUE, choices = colnames(data), selected = c("annee", "etablissement", "discipline", "nombre_de_reponses"))),
                box(width = 9, dataTableOutput("dataTable"))
              )
      ),
      
      # Onglet Graphiques
      tabItem(tabName = "graph",
              fluidRow(
                box(width = 3, selectInput("varnum", "Sélectionnez la variable en ordonnée :", choices = colnames(data)[sapply(data, is.numeric)], selected = "annee")),
                box(width = 9, plotOutput("boxplot"))
              )
      ),
      
      # Onglet Salaires
      tabItem(tabName = "salaire",
              fluidRow(
                box(width = 3, selectInput("varfac", "Sélectionnez la variable en abscisse :", choices = colnames(data)[sapply(data, is.factor)], selected = "domaine")),
                box(width = 5, selectInput("salaire", "Sélectionnez le type de salaire :", choices = c("salaire_brut_annuel_estime", "salaire_net_median_des_emplois_a_temps_plein"), selected = "salaire_net_median_des_emplois_a_temps_plein")),
                box(title = "Salaires par variables catégorielles" ,
                    width = 12, collapsible = TRUE, collapsed = TRUE, plotOutput("salaire_ac")),
                box(title = "Répartition des réponses",
                    width = 12, collapsible = TRUE, collapsed = TRUE, plotOutput("rep_salaires"))
              )
      ),
      
      # Onglet Évolution temporelle
      tabItem(tabName = "evolution",
              fluidRow(
                box(width = 3, selectInput("academie", "Choisir les académies :", choices = unique(data$academie), selected = "Rennes", multiple = TRUE)),
                box(width = 5, selectInput("variable", "Choisir la variable :", choices = list("salaire_brut_annuel_estime", "taux_dinsertion", "taux_de_reponse"), selected = "salaire_brut_annuel_estime")),
                box(width = 12, plotOutput("evolutionPlot")),
              )
      ),
      # Onglet Carte
      tabItem(tabName = "carte",
              fluidRow(
                box(width = 12, leafletOutput("mymap", width = "100%", height = 600))
              )
      )
    )
  )
)

