
library(shiny)

shinyServer(
    function(input, output) {
        output$test <- renderText(input$Budget)
        output$test1 <- renderText(input$Year)
    }
)
