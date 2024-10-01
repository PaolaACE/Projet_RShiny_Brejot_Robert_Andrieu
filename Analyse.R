#Analyses - nouveau point de vue

library(data.table)
library(car)

source("Import_donnees.R")

# modelage du jeu de donnees ----

#on ne garde que les variables qui présentent un intérêt
#et on évite les redondances

data_trie <- data[,c(2,4, 7, 9, 11, 15, 17, 18, 19, 20, 21, 
                        22, 23, 24, 25, 26, 27, 28, 29, 30)]

#on retire les tirets car R les voit comme des signes moins

dta_trie[academie == "Aix-Marseille", academie := "Aix_Marseille"]
dta_trie[academie == "Clermont-Ferrand", academie := "Clermont_Ferrand"]
dta_trie[academie == "Nancy-Metz", academie := "Nancy_Metz"]
dta_trie[academie == "Orléans-Tours", academie := "Orleans_Tours"]

#on retire les lignes "résumées" car elles biaiseront l'analyse

dta_trie <- dta_trie[etablissement != "Toutes universités et établissements assimilés"]

#Principe des analyses ----


#On crée d'abord un generalized linear model

#comme toutes les donnees sont desequilibrees, alors on fera des
#anova de type III


# analyses pour 1 an ----

dta <- dta_trie[annee == 2012]

mod_salaire <- glm(salaire_brut_annuel_estime~
                     academie+
                     discipline+
                     femmes, 
                   data=dta)
Anova(mod_salaire, type = "III")

mod_salaire_dom <- glm(salaire_brut_annuel_estime~
                     academie+
                     domaine+
                    femmes, 
                   data=dta)
Anova(mod_salaire_dom, type = "III")

mod_emploi <- glm(taux_d_emploi~
                     academie+
                     discipline, 
                   data=dta)
Anova(mod_emploi, type = "III")

mod_insertion <- glm(taux_dinsertion~
                       academie+
                       discipline, 
                     data=dta)
Anova(mod_insertion, type = "III")

mod_insertion_dom <- glm(taux_dinsertion~
                         academie+
                         domaine, 
                       data=dta)
Anova(mod_insertion_dom, type = "III")


#generalisation ----

library(emmeans)
emmeans(mod_insertion_dom, ~taux_dinsertion, data = dta)

