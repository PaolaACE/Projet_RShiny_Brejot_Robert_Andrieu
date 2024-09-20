library(data.table)

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
                   header = TRUE, sep = ";", stringsAsFactors = TRUE)

summary(data)



#annee
#diplome
#num_etablissement
#etablissement - A enlever
#etablissement_actuel
#code_academie- A enlever
#academie 
#code_du_domaine - A enlever
#domaine
#code_de_la_discipline - A enlever
#discipline
#situation
#remarque - A enlever
#nombre_de_reponse
#taux_de_reponse
#poids de la discipline
#taux_dinsertion
#taux_d'emploi - a mediter
#taux d'emploi salarie en France
#emplois cadres ou professions intermediaire
#emplois stables
#emplois a plein temps 
#salaire net median des emplois à plein temps
#salaire_brut_annuel estimé
# de diplomes boursiers
# taux de chomage regional
#salaire net mensuel median regional
#emploi cadre
#emploi exterieur à la region de l'universite 
# Femmes
#salaire_net mensuel regional 1er quartile
#salaire net mensuel regional 3 quartile
#clef etablissement 
#cle disc
# id paysage

summary(data$taux_d_emploi)

table(data$etablissement, data$cle_etab)

#axes d'analyses

#Proportion et repartition des emplois par domaine
#Proportion et repartition des salaires par domaine 
#


#penser a mettre a la fin

#femmes

