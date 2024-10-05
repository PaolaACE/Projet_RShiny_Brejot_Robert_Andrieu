library(data.table)
library(shiny)
library(ggplot2)

# #ui.R
# shinyUI(
#   navbarPage("Divide UI and SERVER",
#              source("ui.R", local = TRUE)$value,
#              # source("ui_emily.R", local = TRUE)$value,
#              # source("ui_paola.R", local = TRUE)$value
#              )
# )

# # server.R
# shinyServer(function(input, output, session) {
#   source("server.R", local = TRUE)
#   # source("server_emily.R", local = TRUE)
#   # source("server_paola.R", local = TRUE)
# })
# #Chargement des fonctions
# source("Repartition.R")
# 
# #Chargement des donnees globales
# 
# #sauvegarde d'un resultat/ d'une variable x :
# saveRDS(x, "chemin_fichier.RDS")
# #lecture
# x = readRDS("chemin_fichier")