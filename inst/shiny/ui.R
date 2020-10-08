
library(shiny)
library(shinythemes)

shinyUI(fluidPage(
    theme = shinytheme("cerulean"),
    
    navbarPage(
        title = "API - Example",
        id = "nav",
        tabPanel("Predict", value = "Predict",
                 sidebarLayout(
                     sidebarPanel(("Test Function Predict"),
                         textInput("Budget", "Enter Value", ""),
                         sliderInput("Year",
                                     "Enter your choice Year",
                                     min = 1960,
                                     max = 2020,
                                     value = 1990)
                         
                     ), 
                     mainPanel(
                        textOutput("test"),
                        textOutput("test1")
                     )
                 )
         ),
        tabPanel("Generate", value = "Generate",
                 sidebarLayout(
                     sidebarPanel(),
                     mainPanel()
                 )
        )
    )
))
