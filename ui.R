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
  dashboardHeader(title = "Étude de l'insertion après l'obtention d'un diplôme", titleWidth = 700
  ),
  
  # Sidebar (barre latérale)
  dashboardSidebar(
    sidebarMenu(
      menuItem("Présentation", tabName = "presentation", icon = icon("info-circle")),
      menuItem("Données", tabName = "donnees", icon = icon("table")),
      menuItem("Graphiques", tabName = "graph", icon = icon("chart-bar")),
      menuItem("Salaires", tabName = "salaire", icon = icon("euro-sign")),
      menuItem("Évolution temporelle", tabName = "evolution", icon = icon("line-chart")),
      menuItem("Carte", tabName = "carte", icon = icon("map")),
      menuItem("À propos des auteurs", tabName = "authors", icon = icon("users"))
    )
  ),
  
  # Corps de la page
  dashboardBody(
    tabItems(
      
      #Onglet Présentation
      tabItem(tabName = "presentation",
              h1("Insertion des diplômés de Master"),
              p("Cette application a pour but d'étudier les données de l'insertion des diplômés dans le marché du travail. "),
              
              
              
              h2("Visualisation"),
              p("Plusieurs méthodes de visualisation des données sont proposées. Dans l'onglet Graphiques, on "),
              p("L'onglet Carte permet de visualiser les localisations des académies et les taux de réponse et d'insertions dans chacune de ces acamédies."),
              
              
              h2("Analyse"),
              p("Notre analyse a pour but de déterminer..."),
              
              
              h3("Données accessibles"),
              p("Les données complètes sont accessibles ici : ", 
                tags$a(href = "https://www.data.gouv.fr/fr/datasets/insertion-professionnelle-des-diplomes-de-master-en-universites-et-etablissements-assimiles-donnees-nationales-par-disciplines-detaillees-enquete-insertion-professionnelle/", 
                       "Insertion professionnelle des diplômés de Master")),
              
              h3("Liste des variables"),
              tags$ul(
                tags$li(tags$strong("annee"), " : L'année de la collecte des données."),
                tags$li(tags$strong("diplome"), " : Le type de diplôme obtenu par les diplômés : Master ENS ou LMD."),
                tags$li(tags$strong("numero_de_l_etablissement"), " : Le numéro d'identification de l'établissement."),
                tags$li(tags$strong("etablissement"), " : Nom de l'établissement."),
                tags$li(tags$strong("etablissementactuel"), " : L'établissement où les diplômés ont été formés actuellement."),
                tags$li(tags$strong("code_de_l_academie"), " : Le code de l'académie."),
                tags$li(tags$strong("academie"), " : Nom de l'académie à laquelle appartient l'établissement."),
                tags$li(tags$strong("code_du_domaine"), " : Le code du domaine d'étude."),
                tags$li(tags$strong("domaine"), " : Domaine d'étude du diplôme obtenu."),
                tags$li(tags$strong("code_de_la_discipline"), " : Le code associé à la discipline."),
                tags$li(tags$strong("discipline"), " : Discipline spécifique de l'étude."),
                tags$li(tags$strong("situation"), " : Situation professionnelle des diplômés au moment de l'enquête."),
                tags$li(tags$strong("remarque"), " : Remarques supplémentaires sur les données."),
                tags$li(tags$strong("nombre_de_reponses"), " : Nombre total de réponses reçues pour chaque question."),
                tags$li(tags$strong("taux_de_reponse"), " : Pourcentage de réponse des diplômés."),
                tags$li(tags$strong("poids_de_la_discipline"), " : Poids attribué à chaque discipline dans l'analyse."),
                tags$li(tags$strong("taux_dinsertion"), " : Le taux d’insertion est défini comme étant le pourcentage de diplômés occupant un emploi, quel qu’il soit, sur l’ensemble des diplômés présents sur le marché du travail. Il est calculé sur les diplômés de nationalité française, issus de la formation initiale, entrés immédiatement et durablement sur le marché du travail après l’obtention de leur diplôme en 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019 ou 2020."),
                tags$li(tags$strong("taux_d_emploi"), " : Taux d'emploi : part des diplômés en emploi parmi l'ensemble des diplômés actifs (en emploi ou en recherche) ou inactifs."),
                tags$li(tags$strong("taux_d_emploi_salarie_en_france"), " : Taux d'emploi salarié en France."),
                tags$li(tags$strong("emplois_cadre_ou_professions_intermediaires"), " : Nombre d'emplois occupés par des cadres ou des professions intermédiaires."),
                tags$li(tags$strong("emplois_stables"), " : Taux d'emplois considérés comme stables."),
                tags$li(tags$strong("emplois_a_temps_plein"), " : Nombre d'emplois à temps plein occupés par les diplômés."),
                tags$li(tags$strong("salaire_net_median_des_emplois_a_temps_plein"), " : Salaire net médian pour les emplois à temps plein."),
                tags$li(tags$strong("salaire_brut_annuel_estime"), " : Estimation du salaire brut annuel des diplômés."),
                tags$li(tags$strong("de_diplomes_boursiers"), " : Taux de diplômés boursiers."),
                tags$li(tags$strong("taux_de_chomage_regional"), " : Taux de chômage régional."),
                tags$li(tags$strong("salaire_net_mensuel_median_regional"), " : Salaire net mensuel médian régional."),
                tags$li(tags$strong("emploi_cadre"), " : Nombre d'emplois de cadre occupés par les diplômés."),
                tags$li(tags$strong("emplois_exterieurs_a_la_region_de_luniversite"), " : Emplois trouvés à l'extérieur de la région de l'université."),
                tags$li(tags$strong("femmes"), " : Taux de femmes diplômées dans les réponses."),
                tags$li(tags$strong("salaire_net_mensuel_regional_1er_quartile"), " : Salaire net mensuel du 1er quartile régional."),
                tags$li(tags$strong("salaire_net_mensuel_regional_3eme_quartile"), " : Salaire net mensuel du 3ème quartile régional."),
                tags$li(tags$strong("cle_etab"), " : Clé de l'établissement, identifiant unique."),
                tags$li(tags$strong("cle_disc"), " : Clé de la discipline, identifiant unique."),
                tags$li(tags$strong("id_paysage"), " : Identifiant paysage, utilisé pour des analyses spécifiques.")
              )
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
                box(width = 5, selectInput("variable", "Choisir la variable :", choices = list("salaire_brut_annuel_estime", "taux_d_insertion"), selected = "salaire_brut_annuel_estime")),
                box(width = 12, plotOutput("evolutionPlot"))
              )
      ),
      # Onglet Carte
      tabItem(tabName = "carte",
              fluidRow(
                box(width = 12, leafletOutput("mymap", width = "100%", height = 600))
              )
      ),
      
      # Onglet À propos des auteurs
      tabItem(tabName = "authors",  
              # Onglet À propos des auteurs
              tabItem(tabName = "authors",  
                      h2("À propos des auteurs"),
                      fluidRow(
                        column(width = 6,
                               box(title = "Paola Andrieu", 
                                   status = "primary", 
                                   solidHeader = TRUE,
                                   p("Email : paola.andrieu@example.com")                               )
                        ),
                        column(width = 6,
                               box(title = "Amélie Brejot", 
                                   status = "info", 
                                   solidHeader = TRUE,
                                   p("Email : amelie.brejot@example.com")                               )
                        ),
                        column(width = 6,
                               box(title = "Augustin Robert", 
                                   status = "warning", 
                                   solidHeader = TRUE,
                                   p("Email : augustinrobert03@gmail.com")
                               )
                        )
                      )
              )
              
              
      )
    )
  )
)
