library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(leaflet)
library(dplyr) 
library(tidygeocoder)
library(factoextra)
library(FactoMineR)
library(emmeans)
library(plotly)

source("Import_donnees.R")

dashboardPage(
  
  # Titre de la page
  dashboardHeader(title = "Étude de l'insertion après l'obtention d'un diplôme", titleWidth = 700
  ),
  
  # Sidebar (barre latérale)
  dashboardSidebar(
    sidebarMenu(
      menuItem("Présentation", tabName = "presentation", icon = icon("info-circle")),
      
      menuItem("Visualisation", icon = icon("eye"), 
               menuSubItem("Tableau", tabName = "donnees", icon = icon("table")),
               menuSubItem("Répartitions", tabName = "graph", icon = icon("chart-bar")),
               menuSubItem("Salaires", tabName = "salaire", icon = icon("euro-sign")),
               menuSubItem("Évolution temporelle", tabName = "evolution", icon = icon("line-chart")),
               menuSubItem("Carte", tabName = "carte", icon = icon("map"))
      ),
      menuItem("Analyses", icon = icon("calculator"),
               menuSubItem("AFC sujet/localisation", tabName = "analyse_afc", icon = icon("project-diagram")),
               menuSubItem("AFC salaires", tabName = "analyse_afc_locsal", icon = icon("project-diagram")),
               menuSubItem("Analyse", tabName = "analyse", icon = icon("chart-bar"))
      ),
      menuItem("À propos des auteurs", tabName = "authors", icon = icon("users"))
    )
  ),
  
  # Corps de la page
  dashboardBody(
    tags$head(
      tags$style(
        HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
             ')
      )
    ),
    tabItems(
      
      
      #Onglet Présentation
      tabItem(tabName = "presentation",
              h1("Insertion des diplômés de Master"),
              p("Cette application a pour but d'étudier les données de l'insertion des diplômés dans le marché du travail.
                Les données étudiées sont collectéesdans le cadre de l'opération nationale de collecte de données sur l’insertion professionnelle des diplômés de Master.
                Elles complilent un certain nombre d'informations sur la situation actuelle de diplômé en Master, par année, par établissement, par académie...
                Un individu du tableau correspond à des informations sur l'insertion professionnelle d'une promotion (correspondant à un établissement, une année, 18mois ou 30 mois après le diplôme), les nombres et taux de réponses étant précisés."),
              
              
              
              h2("Visualisation"),
              p("Plusieurs méthodes de visualisation des données sont proposées."),
              tags$ol(
                tags$li("Dans l'onglet Tableau, on peut sélectionner les variables et les observer dans un tableau."),
                tags$li("L'onglet Répartitions nous permet d'observer la répartition des variables quantitatives en fonction des différents domaines. "),
                tags$li("L'onglet Salaires nous donne les moyennes de salaires en fonction de la variable qualitative choisie."),
                tags$li("L'onglet Evolution temporelle rend compte de l'évolution de certaines variables entre 2010 et 2020."),
                tags$li("L'onglet Carte permet de visualiser les localisations des académies et les taux de réponse et d'insertions dans chacune de ces acamédies. La carte est interactive, on observe les taux en cliquant sur les académies.")
              ),
              
              h2("Analyse"),
              tags$ol(
                tags$li("Une première analyse, l'analyse factorielle des correspondances (AFC) entre les localisations et les domaines, permet de situer les académies ou les établissement les uns par rapport aux autres, en fonction de leurs spécialités."),
                tags$li("Une seconde analyse par AFC rend compte des relations entre les niveaux de salaires et les variables géographiques ou de sujet."),
                tags$li("Une analyse de la variance permet d'étudier l'impact des différentes variables sur le salaire brut annuel estimé, le taux d'emploi ou le taux d'insertion")
              ),
              
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
      
      
      
      # Onglet Tableau
      tabItem(tabName = "donnees",
              fluidRow(
                box(width = 3, 
                    h3("Sélectionnez les Variables"),
                    p("Dans cet onglet, vous pouvez sélectionner plusieurs variables 
              à visualiser dans le tableau. Utilisez le sélecteur ci-dessous pour 
              choisir les variables d'intérêt. Le tableau affichera les données 
              correspondantes aux variables sélectionnées."),
                    selectInput("var", "Sélectionnez des variables à visualiser : ", multiple = TRUE, choices = colnames(data), selected = c("annee", "etablissement", "discipline", "nombre_de_reponses"))),
                box(width = 9, dataTableOutput("dataTable"))
              )
      ),
      
      # Onglet Répartitions
      tabItem(tabName = "graph",
              fluidRow(
                box(width = 3,
                    h3("Visualisation des répartitions par domaines"),
                    p("Dans cet onglet, vous pouvez explorer la répartition des différentes variables 
              numériques par domaines. Sélectionnez une variable en ordonnée pour visualiser son 
              boxplot et observer sa distribution."),
                    selectInput("varnum", "Sélectionnez la variable en ordonnée :", choices = colnames(data)[sapply(data, is.numeric)], selected = "annee")),
                box(width = 9, plotlyOutput("boxplot"))
              )
      ),
      
      # Onglet Salaires
      tabItem(tabName = "salaire",
              fluidRow(
                box(width = 6, 
                    h3("Visualisation des Salaires"),
                    p("Dans cet onglet, vous pouvez explorer les salaires en fonction de différentes 
              variables catégorielles. Sélectionnez une variable en abscisse et un type de salaire 
              pour visualiser les tendances."),
                    selectInput("varfac", "Sélectionnez la variable en abscisse :", choices = colnames(data)[sapply(data, is.factor)], selected = "domaine")),
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
                box(width = 6, 
                    h3("Analyse de l'évolution temporelle"),
                    p("Dans cet onglet, vous pouvez explorer l'évolution de certaines variables 
              au fil du temps. Sélectionnez les académies et la variable que vous souhaitez 
              analyser afin de visualiser les tendances dans un graphique."),
                    selectInput("academie", "Choisir les académies :",
                                choices = unique(data$academie), 
                                selected = "Rennes", multiple = TRUE)),
                box(width = 5, selectInput("variable", "Choisir la variable :", choices = list("salaire_brut_annuel_estime", "taux_dinsertion", "taux_de_reponse"), selected = "salaire_brut_annuel_estime")),
                box(width = 12, plotlyOutput("evolutionPlot")),
              )
      ),
      # Onglet Carte
      tabItem(tabName = "carte",
              fluidRow(
                box(width = 12,
                    h3("Description de l'Onglet Carte"),
                    p("Cet onglet présente une carte interactive permettant de visualiser 
              les données en fonction de leur localisation géographique. Vous 
              pouvez explorer les différentes zones géographiques en interagissant 
              directement avec la carte."),
                    p("Cliquez sur les différentes académies pour découvir leur taux de réponse
              et leur taux d'insertion moyen. "),
                    leafletOutput("mymap", width = "100%", height = 600))
              )
      ),
      
      # Onglet AFC Localisation/Sujet
      tabItem(tabName = "analyse_afc",
              sidebarLayout(
                sidebarPanel(
                  title = "Paramètres",
                  width = 3,
                  radioButtons(
                    inputId = "geo_AFC",
                    label = "Niveau géographique",
                    choiceNames = list("Académie", "Etablissement"),
                    choiceValues = list(2, 1),
                    selected = 2
                  ),
                  radioButtons(
                    inputId = "suj_AFC",
                    label = "Niveau de précision du sujet",
                    choiceNames = list("Domaine (5)", "Discipline (20)"),
                    choiceValues = list(3, 4),
                    selected = 3
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
                  actionButton(inputId = "Hop", label = "Lancer l'AFC")
                ),
                mainPanel(
                  title = "Analyse Factorielle des Correspondances",
                  h3("Analyse Factorielle des Correspondances"),
                  p("L'Analyse Factorielle des Correspondances (AFC) est une méthode statistique utilisée 
        pour analyser les relations entre les catégories de variables qualitatives."),
                  p("Cet onglet vous permet d'explorer l'association entre les variables géographiques 
        et de sujet, en fonction des réponses obtenues."),
                  dataTableOutput(outputId = "Conting"),
                  plotOutput(outputId = "plot_AFC"),
                )
              )
      ),
      
      # Onglet AFC des salaires
      tabItem(tabName = "analyse_afc_locsal",
              sidebarLayout(
                sidebarPanel(
                  title = "Paramètres",
                  width = 3,
                  radioButtons(
                    inputId = "var_AFC",
                    label = "Niveau géographique",
                    choiceNames = list("Académie", "Etablissement","Domaine (5)", "Discipline (20)"),
                    choiceValues = list(2, 1, 3, 4),
                    selected = 2
                  ),
                  sliderInput(
                    inputId = "annee_AFC",
                    label = "En quelle année?",
                    value = 2015,
                    min = 2010,
                    max = 2020,
                    round = TRUE,
                    step = 1
                  ),
                  actionButton(inputId = "Tac", label = "Lancer l'AFC")
                ),
                mainPanel(
                  title = "Analyse Factorielle des Correspondances",
                  h3("Description de l'AFC des Salaires"),
                  p("L'Analyse Factorielle des Correspondances (AFC) des salaires permet d'analyser les 
        relations entre les niveaux de salaires et les variables géographiques ou de sujet."),
                  p("Cet onglet vous permet d'explorer les associations entre les salaires et les académies, 
        les établissements, ainsi que les domaines ou disciplines, en fonction des données 
        fournies."),
                  p("La variable salaire_brut_annuel_estime est convertie en variable catégrielle à 3 classes : Faible, Moyen, Elevé. Ces 3 classes sont équilibrées et ont pour valeurs limites 27900 et 49100."),
                  dataTableOutput(outputId = "Contingence"),
                  plotOutput(outputId = "plot_AFC_locsal")
                )
              )
      ),
      
      # Onglet Anova
      tabItem(
        tabName = "analyse",
        fluidRow(
          box(
            title = "Paramètres", 
            width = 4, 
            radioButtons(
              inputId = "Y",
              label = "Quelle variable étudier?",
              choiceNames = list("Salaire brut annuel estimé", 
                                 "Taux d'emploi", 
                                 "Taux d'insertion"),
              choiceValues = list(8, 7, 6), 
              selected = 8
            ),
            radioButtons(
              inputId = "geo",
              label = "Niveau géographique",
              choiceNames = list("Académie", "Établissement"),
              choiceValues = list(3, 2),
              selected = 3
            ),
            radioButtons(
              inputId = "sujet",
              label = "Niveau de précision du sujet",
              choiceNames = list("Domaine (5)", "Discipline (20)"),
              choiceValues = list(4, 5),
              selected = 4
            ),
            sliderInput(
              inputId = "an",
              label = "Sur quelle période ?",
              value = c(2014, 2015),
              min = 2010, 
              max = 2020, 
              round = TRUE, 
              step = 1
            ),
            actionButton(inputId = "Go", label = "Lancer les analyses")
          ),
          
          box(
            title = "Résultats des analyses", 
            h3("Description de l'Analyse de Variance (ANOVA)"),
            p("L'Analyse de Variance (ANOVA) est une méthode statistique utilisée pour comparer 
        les moyennes de plusieurs groupes. Cet onglet vous permet de sélectionner une 
        variable d'intérêt, de définir le niveau géographique et le sujet, ainsi que 
        la période d'analyse."),
            p("Vous pouvez étudier l'impact des différentes variables sur le salaire brut annuel 
        estimé, le taux d'emploi ou le taux d'insertion en fonction de votre sélection."),
            p("Ce tableau présente les dix sujets d'études pour lesquels la variable réponse est 
        la plus haute, selon une analyse réalisée grâce à la fonction emmeans, sur la durée 
        choisie."),
            width = 8, 
            dataTableOutput(outputId = "res_geo"),
            dataTableOutput(outputId = "res_suj")
          )
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
