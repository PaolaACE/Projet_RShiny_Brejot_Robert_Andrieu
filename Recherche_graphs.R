require(ggplot2)
source("Import_donnees.R")

# Répartition des emplois stables par domaine
ggplot(data, aes(x = domaine, y = emplois_stables)) +
  geom_boxplot() +
  labs(title = "Répartition des emplois stables par domaine",
       x = "Domaine", y = "Taux d'emplois stables (%)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Salaire brut annuel estimé par académie
moyenne_par_academie <- data[, .(moyenne_salaire = mean(salaire_brut_annuel_estime, na.rm = TRUE)), by = academie]
ggplot(moyenne_par_academie, aes(x = academie, y = moyenne_salaire, fill = academie)) +
  geom_bar(stat = "identity") +
  labs(title = "Salaire brut annuel moyen estimé par académie", x = "Académie", y = "Salaire brut annuel (€)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

summary(data$salaire_brut_annuel_estime)

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