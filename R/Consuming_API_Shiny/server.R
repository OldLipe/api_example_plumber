
library(shiny)
library(httr)
library(magrittr)

shinyServer(
    function(input, output) {

      response <- httr::POST(url = "http://127.0.0.1:9173/clustering/kmeans/groups?centers=3",
                             body = mtcars, 
                             encode = "json")
      mtcars_df <- lapply(httr::content(response), tibble::as_tibble) %>% dplyr::bind_rows()
      output$test <- renderPlot(plot(mtcars_df$mpg, mtcars_df$cyl, col= mtcars_df$group_id))
        ##output$test <- renderPlot(plot(x = iris$Sepal.Length, y = iris$Sepal.Width))
        ##output$test1 <- renderText(input$Year)
        ##output$l <- render

    }
)
