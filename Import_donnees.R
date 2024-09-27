####Import des packages
require(data.table)

####Import des données

data <- fread(file = "fr-esr-insertion_professionnelle-master.csv", 
                   header = TRUE, sep = ";", stringsAsFactors = F)

data[data == 'ns'] = NA
data[data == 'nd'] = NA

data[, (14:32) := lapply(.SD, as.numeric), .SDcols = 14:32]
data[, (2:13) := lapply(.SD, as.factor), .SDcols = (2:13)]
data[, (33:35) := lapply(.SD, as.factor), .SDcols = (33:35)]

summary(data$taux_d_emploi)
class(data$etablissement)
class(data$id_paysage)

summary(data$taux_d_emploi)
dim(data)

#### Liste des variables
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
data$emplois_exterieurs_a_la_region_de_luniversite
table(data$etablissementactuel, data$etablissement)

data[annee==2013 & etablissement == 'Angers', .N]
data[]
#axes d'analyses

require(ggplot2)

# Répartition des emplois stables par diplôme
ggplot(data, aes(x = diplome, y = emplois_stables)) +
  geom_boxplot() +
  labs(title = "Répartition des emplois stables par diplôme",
       x = "Diplôme", y = "Taux d'emplois stables (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Salaire brut annuel estimé par académie
ggplot(data, aes(x = academie, y = salaire_brut_annuel_estime, fill = academie)) +
  geom_bar(stat = "identity") +
  labs(title = "Salaire brut annuel estimé par académie", x = "Académie", y = "Salaire brut annuel (€)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



# Distribution des salaires nets médians des emplois à temps plein
ggplot(data, aes(x = salaire_net_median_des_emplois_a_temps_plein)) +
  geom_histogram(binwidth = 50, fill = "blue", color = "white") +
  labs(title = "Distribution des salaires nets médians des emplois à temps plein",
       x = "Salaire net médian (€)", y = "Fréquence")

# Corrélation entre proportion de femmes et salaire net médian
ggplot(data, aes(x = femmes, y = salaire_net_median_des_emplois_a_temps_plein)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Proportion de femmes vs Salaire net médian des emplois à temps plein",
       x = "Proportion de femmes (%)", y = "Salaire net médian (€)")

# Taux d'emploi par discipline
ggplot(data, aes(x = discipline, y = taux_d_emploi/100, fill = discipline)) +
  geom_bar(stat = "identity") +
  labs(title = "Taux d'emploi par discipline", x = "Discipline", y = "Taux d'emploi (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Relation entre taux de réponse et taux d'insertion
ggplot(data, aes(x = taux_de_reponse, y = taux_dinsertion)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Taux de réponse vs Taux d'insertion", x = "Taux de réponse (%)", y = "Taux d'insertion (%)")

# Corrélation entre salaire net médian et taux d'emploi
ggplot(data, aes(x = salaire_net_median_des_emplois_a_temps_plein, y = taux_d_emploi)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Salaire net médian vs Taux d'emploi", 
       x = "Salaire net médian (€)", y = "Taux d'emploi (%)")

# Heatmap des taux d'insertion par discipline et académie
ggplot(data, aes(x = discipline, y = academie, fill = taux_dinsertion)) +
  geom_tile() +
  labs(title = "Taux d'insertion par discipline et académie", 
       x = "Discipline", y = "Académie", fill = "Taux d'insertion (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Répartition des emplois stables par emploi cadre ou professions intermédiaires
ggplot(data, aes(x = discipline)) +
  geom_bar(aes(y = emplois_stables, fill = "Emplois stables"), stat = "identity") +
  geom_bar(aes(y = emplois_cadre_ou_professions_intermediaires, fill = "Emplois cadre ou intermédi."), stat = "identity") +
  labs(title = "Répartition des emplois stables et cadres/professions intermédiaires", 
       x = "Discipline", y = "Taux (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
