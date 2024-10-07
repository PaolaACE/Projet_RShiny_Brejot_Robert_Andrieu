####Import des packages
require(data.table)
library(leaflet)
####Import des données

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
              header = TRUE, sep = ";", stringsAsFactors = F)

data[data == 'ns'] = NA
data[data == 'nd'] = NA

data[, c(1,14:32) := lapply(.SD, as.numeric), .SDcols = c(1,14:32)]
data[, (2:13) := lapply(.SD, as.factor), .SDcols = (2:13)]
data[, (33:35) := lapply(.SD, as.factor), .SDcols = (33:35)]

### Préparation données carte ###

## Création du jeu de données des coordonnées des académies

# df <- data %>% group_by(academie) %>%
#   summarise(taux_reponse_totale = mean(taux_de_reponse, na.rm=TRUE), 
#             taux_insertion_moyen = mean(taux_dinsertion, na.rm = TRUE))
# df <- df[2:30,]
# df$academie <- as.character(df$academie)
# df <- df %>%
#   geocode(academie, method = "osm", full_results = TRUE)
# df <- df[,1:5]
# write.csv(df, "coord_academies.csv", row.names = FALSE)

df <- read.csv("coord_academies.csv")
####################  Liste des variables  ###########################
#annee
#diplome
#numero_de_l_etablissement
#etablissement - A enlever
#etablissementactuel
#code_de_l_academie- A enlever
#academie 
#code_du_domaine - A enlever
#domaine
#code_de_la_discipline - A enlever
#discipline
#situation
#remarque - A enlever
#nombre_de_reponses
#taux_de_reponse
#poids_de_la_discipline
#taux_dinsertion
#taux_d_emploi - a mediter
#taux_d_emploi_salarie_en_france
#emplois_cadre_ou_professions_intermediaires
#emplois_stables
#emplois_a_temps_plein 
#salaire_net_median_des_emplois_a_temps_plein
#salaire_brut_annuel_estime
#de_diplomes_boursiers
#taux_de_chomage_regional
#salaire_net_mensuel_median_regional
#emploi_cadre
#emplois_exterieurs_a_la_region_de_luniversite
#femmes
#salaire_net_mensuel_regional_1er_quartile
#salaire_net_mensuel_regional_3eme_quartile
#cle_etab
#cle disc
#id_paysage



