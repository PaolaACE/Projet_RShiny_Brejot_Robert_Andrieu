library(data.table)

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
                   header = TRUE, sep = ";", stringsAsFactors = F)

data[data == 'ns'] = NA
data[data == 'nd'] = NA

data[, (14:32) := lapply(.SD, as.numeric), .SDcols = 14:32]
data[, (2:31) := lapply(.SD, as.factor), .SDcols = (2:31)]
data[, (33:35) := lapply(.SD, as.factor), .SDcols = (33:35)]

summary(data$taux_d_emploi)
class(data$etablissement)
class(data$id_paysage)

summary(data$taux_d_emploi)
dim(data)

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

summary(data$taux_d_emploi)
summary(data$diplome)
summary(data$emplois_cadre_ou_professions_intermediaires)
summary(data$situation)

table(data$etablissementactuel, data$etablissement)


#axes d'analyses

#Proportion et repartition des emplois par domaine
#Proportion et repartition des salaires par domaine 
#Repartition des emplois en fonction de la situation (18 ou 30 mois après le diplôme)


#penser a mettre a la fin

#femmes

