#Analyses - nouveau point de vue

library(data.table)
library(car)

source("Import_donnees.R")

# modelage du jeu de donnees ----

data_trie <- data[,c(1,2,4, 7, 9, 11, 15, 17, 18, 19, 20, 21, 
                        22, 23, 24, 25, 26, 27, 28, 29, 30)]

dta_trie[academie == "Aix-Marseille", academie := "Aix_Marseille"]
dta_trie[academie == "Clermont-Ferrand", academie := "Clermont_Ferrand"]
dta_trie[academie == "Nancy-Metz", academie := "Nancy_Metz"]
dta_trie[academie == "Orléans-Tours", academie := "Orleans_Tours"]

dta_trie <- dta_trie[etablissement != "Toutes universités et établissements assimilés"]

# analyses pour 1 an ----

dta <- dta_trie[annee == 2011]
mod_salaire <- glm(salaire_brut_annuel_estime~
                     academie+
                     diplome+
                     diplome:discipline+
                     domaine, 
                   data=)



#generalisation ----