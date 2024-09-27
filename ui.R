library(shiny)



# Define UI for application that draws a histogram
fluidPage(
  
  navbarPage(
    title = "Etude de l'insertion après l'obtention d'un diplome",
    tabPanel(
      title = "Présentation",
      sidebarLayout(
        sidebarPanel(
          checkboxGroupInput(inputId = "var", label = "Variables : ", choices = colnames(data))
        ),
        mainPanel(
          dataTableOutput(outputId = "dataTable")
        )
      ),
      
    ),
    
    tabPanel(
      title = "Emplois par domaines"
    ),
    
    navbarMenu(
      title = "Salaires",
      tabPanel(
        title = "Par académie",
        plotOutput("salaire_ac")
      ),
      tabPanel(
        title = "Par emploi"
      ),
      tabPanel(
        title = "Répartition des salaires",
        plotOutput("rep_salaires")
      )
    )
  )
)


