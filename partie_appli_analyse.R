#A implémenter dans l'application
library(shiny)
?checkboxGroupInput

#POUR UI ----

tabPanel{ 
  checkboxGroupInput(
    inputId = "geo",
    label = "Niveau geographique",
    choiceNames = list("Académie", "Etablissement"),
    choiceValues = list("academie", "etablissement")
  ),
  
  checkboxGroupInput(
    inputId = "sujet",
    label = "Niveau de précision du sujet",
    choiceNames = list("Domaine (5)", "Discipline(20)"),
    choiceValues = list("domaine", "discipline")
  ), 
  
  sliderInput(
    inputId = "an",
    label = "Sur quelle période? ",
    value = 2015,
    min = 2010, 
    max = 2020, 
    round = TRUE, 
    step = 1, 
  ), 
  
  mainPanel(
    verbatimTextOutput(output$res.aov)
  )
  
}

#POUR SERVER

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


#POUR SERVER ----

for (a in input$an[1]:input$an[2]){
  print(a)
  mod <- glm(input$Y ~ input$geo + input$sujet + femmes +
               input$geo:input$sujet +
               input$geo:femmes+
               input$sujet:femmes, data = dta)
  output$res.aov <- summary(Anova(mod, type = "III"))
}

